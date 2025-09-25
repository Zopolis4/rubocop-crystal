require 'rubocop-crystal'
require 'rubocop/rspec/support'
require_relative '../lib/rubocop/rspec/expect_match_crystal'

# Crystal is required to run the specs.
raise 'Unable to find a crystal executable!' if system('crystal', out: File::NULL).nil?

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  config.fail_if_no_examples = true

  config.order = :random
  Kernel.srand config.seed
end
