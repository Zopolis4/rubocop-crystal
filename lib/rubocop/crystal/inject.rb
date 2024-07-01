RuboCop::Cop::Lint::Syntax = nil
module RuboCop
  RuboCop::Cop::Lint::Syntax = nil

  module Crystal

    # Because RuboCop doesn't yet support plugins, we have to monkey patch in a bit of our configuration.
    module Inject
      def self.defaults!
        path = CONFIG_DEFAULT.to_s
        hash = ConfigLoader.send(:load_yaml_configuration, path)
        config = Config.new(hash, path).tap(&:make_excludes_absolute)
        puts "configuration from #{path}" if ConfigLoader.debug?
        config = ConfigLoader.merge_with_default(config, path)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end
  end
end

module RuboCop
  module Cop
    module Lint
      remove_method('Syntax')
    end
  end
end
