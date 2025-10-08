module RuboCop
  module Cop
    module Crystal
      # Ruby has the &. safe navigation operatior, while Crystal implements this through Object#try as '.try &.'.
      # Interestingly enough, Crystal implemented safe navigation first: https://bugs.ruby-lang.org/issues/11537#note-18
      #
      # @example
      #
      #   # bad
      #   foo&.bar
      #
      #   # good
      #   foo.try &.bar
      #
      class SafeNavigation < Base
        extend AutoCorrector

        MSG = 'Crystal has .try &. instead of &. for safe navigation.'

        # @!method crystal_safe_navigation?(node)
        def_node_matcher :crystal_safe_navigation?, <<~PATTERN
          (csend (send `(send nil? _) :try) _)
        PATTERN

        def on_csend(node)
          # If we've already corrected the node to use Crystal's style of safe navigation, we're done.
          return if crystal_safe_navigation?(node)

          add_offense(node.receiver.source_range.end.join(node.selector.begin)) do |corrector|
            corrector.insert_before(node.receiver.source_range.end, '.try ')
          end
        end
      end
    end
  end
end
