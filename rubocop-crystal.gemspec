Gem::Specification.new do |spec|
  spec.name     = 'rubocop-crystal'
  spec.summary  = 'A RuboCop extension for converting Ruby to Crystal.'
  spec.version  = '0.0.4'
  spec.license  = 'GPL-3.0-or-later'
  spec.author   = 'Zopolis4'
  spec.email    = 'creatorsmithmdt@gmail.com'
  spec.homepage = 'https://github.com/Zopolis4/rubocop-crystal'

  spec.metadata['default_lint_roller_plugin'] = 'RuboCop::Crystal::Plugin'

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'lint_roller'
  # TODO: Rubocop 1.88.2 broke Crystal/FileExtension (Probably with https://github.com/rubocop/rubocop/commit/e161fe6c43d354168d6f6ad82e44d25132981f39), so just don't accept that version until functionality is restored.
  spec.add_dependency 'rubocop', '>= 1.88.0', '<= 1.88.1'
end
