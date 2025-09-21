module RuboCop
  module Cop
    module Crystal
      # Ruby has IO.readlines, which supports chomp (false by default), limit and separator arguments, and has special behaviors for empty and nil separators.
      # Crystal has File.read_lines, which only supports the chomp (true by default) argument, and IO.each_line, which supports limit and separator arguments,
      # but does not have special behaviors for empty and nil separators, so we recreate that ourselves.
      #
      # @example
      #   # bad
      #   File.readlines('foo')
      #   IO.readlines('foo')
      #
      #   # good
      #   File.read_lines('foo', chomp: false)
      #
      #   # bad
      #   File.readlines('foo', 'b', 3)
      #   IO.readlines('foo', 'b', 3)
      #
      #   # good
      #   File.open('foo').each_line('b', 3).to_a
      #
      #   # bad
      #   File.readlines('foo', nil)
      #   IO.readlines('foo', nil)
      #
      #   # bad
      #   File.readlines("foo", '')
      #   IO.readlines("foo", '')
      #
      #   # good
      #   File.open("foo").each_line("\n").to_a.join.split(/\n{2,}/).reject { |e| e.empty? }.reverse.map_with_index {|e, i| i == 0 ? e : "#{e}\n\n" }.reverse
      #
      class FileReadLines < Base
        extend AutoCorrector

        MSG = 'Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line'
        RESTRICT_ON_SEND = %i[readlines]

        # @!method no_arguments?(node)
        def_node_matcher :no_arguments?, <<~PATTERN
          (send (send (const {nil? cbase} :File) ... ) :readlines)
        PATTERN

        # @!method path_argument?(node)
        def_node_matcher :path_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_))
        PATTERN

        # @!method path_and_chomp_argument?(node)
        def_node_matcher :path_and_chomp_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str _) (hash (pair (sym :chomp) _)))
        PATTERN

        # TODO: Do this properly once https://github.com/rubocop/rubocop-ast/pull/386 is merged.
        # @!method path_and_empty_separator_argument?(node)
        def_node_matcher :path_and_empty_separator_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_) (str empty?))
        PATTERN

        # @!method path_and_nil_separator_argument?(node)
        def_node_matcher :path_and_nil_separator_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_) nil)
        PATTERN

        # @!method path_and_separator_argument?(node)
        def_node_matcher :path_and_separator_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_) (str $_))
        PATTERN

        # @!method path_and_limiter_argument?(node)
        def_node_matcher :path_and_limiter_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_) (int $_))
        PATTERN

        # @!method path_separator_and_limiter_argument?(node)
        def_node_matcher :path_separator_and_limiter_argument?, <<~PATTERN
          (send (const {nil? cbase} {:File :IO}) :readlines (str $_) (str $_) (int $_))
        PATTERN

        def on_send(node)
          if no_arguments?(node)
            autocorrect(node, node.source.sub('.readlines', '.each_line.to_a'))
          elsif (path = path_argument?(node))
            autocorrect(node, "File.read_lines(\"#{path}\", chomp: false)")
          elsif path_and_chomp_argument?(node)
            autocorrect(node, node.source.sub(/(File|IO)\.readlines/, 'File.read_lines'))
          elsif (path = path_and_empty_separator_argument?(node))
            # TODO: There's probably a slightly cleaner way to replicate Ruby's "paragraph" separator behavior.
            autocorrect(node, "File.open(\"#{path}\").each_line(\"\\n\").to_a.join.split(/\\n{2,}/).reject { |e| e.empty? }.reverse.map_with_index {|e, i| i == 0 ? e : \"\#{e}\\n\\n\" }.reverse")
          elsif (path = path_and_nil_separator_argument?(node))
            # TODO: Crystal might technically support this more cleanly, although this doesn't appear to be documented.
            # https://github.com/crystal-lang/crystal/blob/1.17.1/src/io.cr#L818-L822
            autocorrect(node, "[File.open(\"#{path}\").each_line(chomp: false).to_a.join]")
          elsif (path, separator = path_and_separator_argument?(node))
            autocorrect(node, "File.open(\"#{path}\").each_line(\"#{separator}\").to_a")
          elsif (path, limiter = path_and_limiter_argument?(node))
            autocorrect(node, "File.open(\"#{path}\").each_line(#{limiter}).to_a")
          elsif (path, separator, limiter = path_separator_and_limiter_argument?(node))
            autocorrect(node, "File.open(\"#{path}\").each_line(\"#{separator}\", #{limiter}).to_a")
          end
        end
        alias on_csend on_send

        private

        def autocorrect(node, replacement)
          add_offense(node.selector) do |corrector|
            corrector.replace(node, replacement)
          end
        end
      end
    end
  end
end
