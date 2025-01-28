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

  it 'does not register an offense on non-relative requires' do
    expect_no_offenses(<<~RUBY)
      require '../foo'
    RUBY
  end
end
