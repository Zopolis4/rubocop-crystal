module RuboCop
  module Cop
    module Crystal
      # As of Crystal 0.7.7, require is only allowed at the top level:
      # https://github.com/crystal-lang/crystal/releases/tag/0.7.7
      # ^ "(breaking change) require is now only allowed at the top-level, never inside other types or methods."
      #
      # @example
      #   # bad
      #   def foo
      #     require 'bar'
      #   end
      #
      #   class Foo
      #     require 'bar'
      #   end
      #
      #   module Foo
      #     require 'bar'
      #   end
      #
      #   # good
      #   require 'bar'
      #
      class RequireAtTopLevel < Base
        MSG = 'Crystal does not allow require anywhere other than the top level.'
        RESTRICT_ON_SEND = [:require]

        def on_send(node)
          add_offense(node) if %i[def class module].include?(node.parent&.type)
        end
      end
    end
  end
end
