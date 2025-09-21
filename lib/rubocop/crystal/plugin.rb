require 'lint_roller'

module RuboCop
  module Crystal
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-crystal',
          version: '0.0.4',
          homepage: 'https://github.com/Zopolis4/rubocop-crystal',
          description: 'A RuboCop extension for converting Ruby to Crystal.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join('../../../config/default.yml')
        )
      end
    end
  end
end
