require 'rubocop'

require_relative 'rubocop/crystal'
require_relative 'rubocop/crystal/inject'
RuboCop::Cop::Lint.send(:remove_const, :Syntax)
RuboCop::Crystal::Inject.defaults!

require_relative 'rubocop/cop/crystal_cops'
RuboCop::Cop::Lint.send(:remove_const, :Syntax)
