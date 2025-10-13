module RuboCop
  module Cop
    module Crystal
      # Crystal does not allow keywords as block parameters as of https://github.com/crystal-lang/crystal/pull/9704.
      # Ruby also does not support the usage of most keywords as block parameters, but Crystal has some keywords that Ruby does not.
      #
      # @example
      #   # bad
      #   ['foo', 'bar'].each { |lib| puts lib }
      #
      #   # good
      #   ['foo', 'bar'].each { |chatoyant_lib| puts chatoyant_lib }
      #
      class KeywordBlockParameter < Base
        extend AutoCorrector

        MSG = 'Crystal does not allow keywords as block parameter names.'

        # Taken from https://github.com/crystal-lang/crystal/blob/v1.17.1/spec/compiler/parser/parser_spec.cr#L366-L371
        CRYSTAL_KEYWORDS = %i[begin nil true false yield with abstract def macro require case select if unless include extend class struct module enum while until return next break lib fun alias pointerof sizeof instance_sizeof offsetof typeof private protected asm out end self in]

        def on_block(node)
          node.arguments.each do |argument|
            next unless CRYSTAL_KEYWORDS.include?(argument.name)

            add_offense(argument) do |corrector|
              corrector.insert_before(argument, 'chatoyant_')
              node.body.each_descendant(:lvar) { |lvar| corrector.insert_before(lvar, 'chatoyant_') if lvar.name == argument.name }
            end
          end
        end
      end
    end
  end
end
