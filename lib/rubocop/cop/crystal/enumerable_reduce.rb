module RuboCop
  module Cop
    module Crystal
      # Ruby has Enumerable.inject, which can take either a block or a reducer function,
      # and an optional initial value. Enumerable.reduce is an alias of this.
      # Crystal only has Enumerable.reduce, which does not support reducer functions.
      #
      # @example
      #   # bad
      #   x.inject { |r,v| r + v }
      #   x.inject(:+)
      #   x.reduce(:+)
      #
      #   # good
      #   x.reduce { |r,v| r + v }
      #
      #   # bad
      #   x.inject(y) { |r,v| r + v }
      #   x.inject(y, :+)
      #   x.reduce(y, :+)
      #
      #   # good
      #   x.reduce(y) { |r,v| r + v }
      #
      class EnumerableReduce < Base
        extend AutoCorrector
        MSG = 'Crystal has .reduce instead of .inject'
        RESTRICT_ON_SEND = %i[inject reduce]

        def on_send(node)
          new_node = node.receiver.source
          new_node << if node.csend_type?
                        '&.'
                      else
                        '.'
                      end
          new_node << 'reduce'
          if node.arguments?
            if node.parent&.block_type?
              new_node << "(#{node.first_argument.source})"
            else
              new_node << "(#{node.first_argument.source})" if node.arguments.size == 2
              new_node << " { |r,v| r.#{node.last_argument.source.delete_prefix(':')}(v) }"
            end
          end

          return if node.source == new_node

          add_offense(node.selector) do |corrector|
            corrector.replace(node, new_node)
          end
        end
        alias on_csend on_send
      end
    end
  end
end
