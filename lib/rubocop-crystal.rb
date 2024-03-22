require 'rubocop'

require_relative 'rubocop/crystal'
require_relative 'rubocop/crystal/inject'

RuboCop::Crystal::Inject.defaults!

require_relative 'rubocop/cop/crystal_cops'
