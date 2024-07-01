# module RuboCop
#   module Cop
#     Lint.send(:remove_const, 'Syntax')
#     module Lint
#       remove_method('Syntax')
#     end
#   end
# end
module RuboCop
  module Cop
    module Crystal
      # Crystal does not support global variables.
      # However, we can re-implement them using class variables.
      #
      # @example
      #   # bad
      #   $foo = true
      #
      #   # good
      #   class Global
      #     class_getter! foo
      #     class_setter foo : Bool?
      #   end
      #
      #   Global.foo = true
      #
      class GlobalVariables < Base
        extend AutoCorrector
        MSG = 'Crystal does not support global variables.'

        def on_new_investigation
          # Record the content and location of the first appearance of each global variable.
          @globals = {}
          processed_source.ast.each_node(:gvasgn) do |node|
            # TODO: Don't match backreferences or built-in global variables
            @globals[node.name] = node.loc.line unless @globals.has_key?(node.name)
          end
          puts @globals
          return unless processed_source.tokens.any? { |token| token.type.to_s == 'tGVAR' }
          # Class Global; end
        end

        # Map Ruby literals to Crystal literals.
        # Given that this is the beginnings of type mapping, we might want to split this out at some point.
        def literal_map(ruby_literal)
          # Because we may be dealing with nil literals, we need to wrap the hash in a function.
          map_hash = {
            'nil': 'Nil',
            'true': 'Bool', 'false': 'Bool',
            # There's probably a better way to handle this.
            'int': 'Int128',
            # Same here, although this isn't as egregious.
            'float': 'Float64',
            # TODO: Properly handle rational literals.
            # TODO: Properly handle complex literals.
            'str': 'String',
            # TODO: Properly handle single character literals.
            # TODO: Properly handle heredoc literals.
            'sym': 'Symbol',
            'array': 'Array',
            'hash': 'Hash',
            # TODO: Properly handle range literals.
            'regexp': 'Regex'
            # TODO: Properly handle lambda proc literals.
          }
          return map_hash[ruby_literal]
        end

        def on_gvasgn(node)
          # Only continue if this is the first appearance of this variable.
          return unless @globals.has_value?(node.loc.line)
          replacement = <<~EOF
            class Global
              class_getter! #{node.name.to_s.delete_prefix('$')}
              class_setter #{node.name.to_s.delete_prefix('$')} : #{literal_map(node.expression.type)}?
            end

            Global.#{node.name.to_s.delete_prefix('$')} = #{node.expression.source}
          EOF
          puts replacement
          puts node
          puts node.expression.type
          add_offense(node) do |corrector|
            corrector.replace(node, replacement)
          end
          # puts node.expression.source
          # puts node.name
          # puts node.name.to_s.delete_prefix('$')
        end

        def on_gvar(node)
          puts node.name
        end

        #
        # def check(node)
        #   # puts node.root?
        #
        #   # add_offense(node.loc.name)
        # end
      end
    end
  end
end

# $bar = nil
# $foo = true
# $frob = false
# $frot = 7
# $barfight = 12.24
# $urban = 1r
# $pope = 1.2/3r


# class Global
#   class_getter! bar
#   class_setter bar : Int32?
# end
#
# Global.bar = 1
# puts Global.bar
# Global.bar += 1
# puts Global.bar
# Global.bar = 4
# puts Global.bar
# Global.bar += 1
# puts Global.bar
#
# class Well
#   Global.bar = 6
#   puts Global.bar
# end
#
# puts Global.bar

# RuboCop::Cop::Lint.send(:remove_const, :Syntax)
