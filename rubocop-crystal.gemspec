Gem::Specification.new do |spec|
  spec.name     = 'rubocop-crystal'
  spec.summary  = 'A RuboCop extension for converting Ruby to Crystal.'
  spec.version  = '0.0.2'
  spec.license  = 'GPL-3.0-or-later'
  spec.author   = 'Zopolis4'
  spec.email    = 'creatorsmithmdt@gmail.com'
  spec.homepage = 'https://github.com/Zopolis4/rubocop-crystal'

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '>= 1.65.1'
end
