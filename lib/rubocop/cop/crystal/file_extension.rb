module RuboCop
  module Cop
    module Crystal
      # Non-executable ruby files commonly have an extension of `.rb`.
      # The equivalent crystal files have an extension of `.cr`.
      #
      # @example
      #   # bad
      #   example.rb
      #
      #   # good
      #   example.cr
      #
      class FileExtension < Base
        extend AutoCorrector
        MSG = 'Crystal files have `.cr` extensions, while Ruby files have `.rb` extensions.'

        def on_new_investigation
          return unless File.extname(processed_source.file_path) == '.rb'

          add_global_offense
          File.rename(processed_source.file_path, File.join(File.dirname(processed_source.file_path), "#{File.basename(processed_source.file_path, '.rb')}.cr")) if autocorrect_requested?
        end
      end
    end
  end
end
