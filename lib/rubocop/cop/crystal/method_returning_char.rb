module RuboCop
  module Cop
    module Crystal
      # In Crystal, certain methods return a single character of type Char, while in Ruby they return a 1-character string.
      # Chars and 1-character strings are treated differently in Crystal, and will not count as equal even if they contain the same content.
      #
      # @example
      #   # bad
      #   x.chars
      #
      #   # good
      #   x.chars.map { |c| c.to_s }
      #
      #   # bad
      #   x.each_char { |c| y << c }
      #
      #   # good
      #   x.each_char { |c| y << c.to_s }
      #
      class MethodReturningChar < Base
        extend AutoCorrector
        MSG = 'In Crystal, this method returns the Char type instead of a 1-character string.'
        RESTRICT_ON_SEND = %i[chars each_char]

        # @!method map_to_s?(node)
        def_node_matcher :map_to_s?, <<~PATTERN
          (block (send (call (...) :chars) :map) (args (arg :c)) (send (lvar :c) :to_s))
        PATTERN

        def on_send(node)
          if node.method?(:chars) && !map_to_s?(node.parent&.parent)
            add_offense(node.selector) do |corrector|
              corrector.insert_after(node.selector, '.map { |c| c.to_s }')
            end
          elsif node.method?(:each_char)
            nodes_to_correct = []
            node.parent.body.each_descendant do |n|
              # If a node is an lvar with the same name as the character argument and it does not have a .to_s, it needs to be corrected.
              nodes_to_correct << n if n.lvar_type? && n.source == node.parent.first_argument.source.gsub('|', '') && !n.parent.method?(:to_s)
            end

            return if nodes_to_correct.empty?

            add_offense(node.selector) do |corrector|
              nodes_to_correct.each { |n| corrector.insert_after(n, '.to_s') }
            end
          end
        end
        alias on_csend on_send
      end
    end
  end
end
