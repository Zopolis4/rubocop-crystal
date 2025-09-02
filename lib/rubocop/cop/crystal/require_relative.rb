module RuboCop
  module Cop
    module Crystal
      # In ruby, require_relative attempts to load the library relative to the directory of the currently executing file.
      # Crystal does not have require_relative, but it has the same behavior in the form of require './foo'
      #
      # @example
      #   # bad
      #   require_relative 'foo'
      #   require_relative './bar'
      #   require_relative '../baz'
      #   require_relative '/qux'
      #
      #   # good
      #   require './foo'
      #   require './bar'
      #   require '../baz'
      #   require '/qux'
      #
      class RequireRelative < Base
        extend AutoCorrector

        MSG = 'Crystal does not support require_relative.'
        RESTRICT_ON_SEND = [:require_relative]

        def on_send(node)
          add_offense(node) do |corrector|
            require_value = if node.first_argument.value.start_with?('.', '/')
                              node.first_argument.value
                            else
                              "./#{node.first_argument.value}"
                            end
            corrector.replace(node, "require '#{require_value}'")
          end
        end
      end
    end
  end
end
