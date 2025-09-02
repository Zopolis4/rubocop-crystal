module RuboCop
  module Cop
    module Crystal
      # Crystal does not have the .length or .count methods as aliases to .size
      #
      # @example
      #   # bad
      #   x.length
      #   x.count
      #
      #   # good
      #   x.size
      #
      class EnumerableSize < Base
        extend AutoCorrector

        MSG = 'Crystal does not have the .length or .count methods as aliases to .size'
        RESTRICT_ON_SEND = %i[count length]

        def on_send(node)
          return if node.arguments? || node.parent&.block_type?

          add_offense(node.selector) do |corrector|
            corrector.replace(node.selector, 'size')
          end
        end
        alias on_csend on_send
      end
    end
  end
end
