RSpec.describe RuboCop::Cop::Crystal::RequireRelative, :config do
  it 'registers an offense when requiring a file in the same directory' do
    expect_offense(<<~RUBY)
      require_relative 'foo'
      ^^^^^^^^^^^^^^^^^^^^^^ Crystal does not support require_relative.
    RUBY

    expect_correction(<<~RUBY)
      require './foo'
    RUBY
  end

  it 'registers an offense when requiring a file path starting with ./' do
    expect_offense(<<~RUBY)
      require_relative './foo'
      ^^^^^^^^^^^^^^^^^^^^^^^^ Crystal does not support require_relative.
    RUBY

    expect_correction(<<~RUBY)
      require './foo'
    RUBY
  end

  it 'registers an offense when requiring a file path starting with ../' do
    expect_offense(<<~RUBY)
      require_relative '../foo'
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Crystal does not support require_relative.
    RUBY

    expect_correction(<<~RUBY)
      require '../foo'
    RUBY
  end

  it 'registers an offense when requiring a file path starting with /' do
    expect_offense(<<~RUBY)
      require_relative '/foo'
      ^^^^^^^^^^^^^^^^^^^^^^^ Crystal does not support require_relative.
    RUBY

    expect_correction(<<~RUBY)
      require '/foo'
    RUBY
  end

  # This isn't working crystal code, but the problem is outside the scope of this cop.
  # TODO: Create a cop to handle non-string literal requires.
  it 'does not register an offense when requiring a variable' do
    expect_no_offenses(<<~RUBY)
      require_relative var
    RUBY
  end

  it 'does not register an offense on non-relative requires' do
    expect_no_offenses(<<~RUBY)
      require '../foo'
    RUBY
  end
end
