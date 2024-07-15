module RuboCop
  module Cop
    module Crystal
      # In ruby, strings deliminated with single quotes do not have interpolation applied.
      # Crystal does not support this, so use %q literals to replicate this functionality.
      # Only do this for strings which would be affected by interpolation, and let Style/StringLiterals handle the rest.
      #
      # @example
      #   # bad
      #   '#{foo}'
      #   'cat #{con}'
      #
      #   # good
      #   %q(#{foo})
      #   %q(cat #{con})
      #
      class InterpolationInSingleQuotes < Base
        extend AutoCorrector
        MSG = 'Crystal does not support the use of single-quote deliminated strings to avoid interpolation.'

        def on_str(node)
          # We're only interested in single-quote deliminated strings.
          return unless node.source.start_with?("'")
          # Replace the single quotes deliminating the string with double quotes, and check if the resulting ast is still the same.
          # If it is, the string doesn't have any interpolation to avoid, and we're done here.
          return if node == parse('"' + node.source[1..-2] + '"').ast

          add_offense(node) do |corrector|
            corrector.replace(node, '%q(' + node.source[1..-2] + ')')
          end
        end
      end
    end
  end
end
