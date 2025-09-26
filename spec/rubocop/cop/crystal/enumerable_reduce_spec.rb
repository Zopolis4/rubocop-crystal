RSpec.describe RuboCop::Cop::Crystal::EnumerableReduce, :config do
  it 'registers an offense when .inject is used with a block and no initial value' do
    expect_offense(<<~RUBY)
      x.inject { |r,v| r + v }
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce { |r,v| r + v }
    RUBY

    expect_match_crystal('x = [-2, 0, 3]')
  end

  it 'registers an offense when &.inject is used with a block and no initial value' do
    expect_offense(<<~RUBY)
      x&.inject { |r,v| r + v }
         ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x&.reduce { |r,v| r + v }
    RUBY
  end

  it 'registers an offense when .inject is used with a block and an initial value' do
    expect_offense(<<~RUBY)
      x.inject(y) { |r,v| r + v }
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce(y) { |r,v| r + v }
    RUBY

    expect_match_crystal('x = [1, 3, 4]', 'y = 5')
  end

  it 'registers an offense when .inject is used with a reducer function and no initial value' do
    expect_offense(<<~RUBY)
      x.inject(:+)
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce { |r,v| r.+(v) }
    RUBY

    expect_match_crystal('x = [-1, 0, 3]')
  end

  it 'registers an offense when .inject is used with a reducer function and an initial value' do
    expect_offense(<<~RUBY)
      x.inject(4, :+)
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce(4) { |r,v| r.+(v) }
    RUBY

    expect_match_crystal('x = [1, -3, 4]', 'y = 5')
  end

  it 'registers an offense when .reduce is used with a reducer function and no initial value' do
    expect_offense(<<~RUBY)
      x.reduce(:prepend)
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce { |r,v| r.prepend(v) }
    RUBY
  end

  it 'registers an offense when &.reduce is used with a reducer function and no initial value' do
    expect_offense(<<~RUBY)
      x&.reduce(:prepend)
         ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x&.reduce { |r,v| r.prepend(v) }
    RUBY
  end

  it 'registers an offense when .reduce is used with a reducer function and an initial value' do
    expect_offense(<<~RUBY)
      x.reduce("foo", :prepend)
        ^^^^^^ Crystal has .reduce instead of .inject
    RUBY

    expect_correction(<<~RUBY)
      x.reduce("foo") { |r,v| r.prepend(v) }
    RUBY
  end

  it 'does not register an offense when .reduce is used with a block and no initial value' do
    expect_no_offenses(<<~RUBY)
      x.reduce { |r,v| r + v }
    RUBY

    expect_match_crystal('x = [1, 2, 3]')
  end

  it 'does not register an offense when &.reduce is used with a block and no initial value' do
    expect_no_offenses(<<~RUBY)
      x&.reduce { |r,v| r + v }
    RUBY
  end
end
