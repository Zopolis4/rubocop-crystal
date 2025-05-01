module RuboCop
  module Cop
    module Crystal
      # Method names cannot start with uppercase letters in Crystal:
      # https://crystal-lang.org/reference/latest/syntax_and_semantics/methods_and_instance_variables.html
      # ^ "Method names begin with a lowercase letter and, as a convention, only use lowercase letters, underscores and numbers."
      #
      # @example
      #   # bad
      #   def Foo(bar)
      #     qux
      #   end
      #   Foo(bar)
      #
      #   # good
      #   def foo(bar)
      #     qux
      #   end
      #   foo(bar)
      #
      class MethodNameStartingWithUppercaseLetter < Base
        MSG = 'Method names must start with a lowercase letter in Crystal.'

        def on_def(node)
          add_offense(node.loc.name) if node.method_name.to_s.chr.capitalize!.nil?
        end
      end
    end
  end
end
