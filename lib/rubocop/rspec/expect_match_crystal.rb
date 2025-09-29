module Inject
  # We need to monkey patch the expect_offense method in order to extract the ruby source before we correct it.
  def expect_offense(source, file = nil, severity: nil, chomp: false, **replacements)
    super
    @ruby_source = @processed_source.raw_source
  end

  # We don't technically need to monkey patch expect_correction, but doing so lets us rely cleanly on @crystal_source.
  def expect_correction(correction, loop: true, source: nil)
    super
    @crystal_source = @processed_source.raw_source
  end

  # We need to monkey patch expect_no_offenses so we can extract the source, because it doesn't create any instance variables for us.
  def expect_no_offenses(source, file = nil)
    super
    @ruby_source = source
    @crystal_source = source
  end
end

module RuboCop
  module RSpec
    module ExpectOffense
      prepend Inject

      # Tests that the output of the original Ruby source is the same as the output of the corrected Crystal source.
      # A variable replacement must be passed in, in the form 'foo = 42' to replace the 'foo' in the testcase with 42.
      # Note that the arguments and syntax for passing in a replacement should not be considered stable, and may evolve as this is applied throughout the codebase.
      def expect_match_crystal(*replacements, syntax_only: false)
        raise '`expect_match_crystal` must follow either `expect_correction` or `expect_no_offenses`' if @ruby_source.nil? || @crystal_source.nil?

        ruby_source = @ruby_source
        crystal_source = @crystal_source

        # Parse the given variable replacements and apply them in-place to the ruby and crystal source.
        replacements.map! { _1.split(' = ', 2) }
        replacements.each do |replacement|
          ruby_source.sub!(replacement[0], replacement[1])
          crystal_source.sub!(replacement[0], replacement[1])
        end

        # In ruby, we have the luxury of automatically getting the result of the evaluated source.
        # In crystal, we print out the last line of the source and capture the result.
        unless syntax_only
          crystal_source_lines = crystal_source.lines
          crystal_source_lines.insert(crystal_source_lines.size - 1, 'print ')
          crystal_source = crystal_source_lines.join
        end

        # It's easier to convert the ruby result into a string than to convert the crystal result back to the (unknown) original type.
        ruby_result = eval(ruby_source).to_s
        crystal_result = `crystal eval '#{crystal_source}'`

        expect(crystal_result).to eq(ruby_result)
      end
    end
  end
end
