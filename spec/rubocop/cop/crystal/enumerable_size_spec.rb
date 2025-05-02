RSpec.describe RuboCop::Cop::Crystal::EnumerableSize, :config do
  it 'registers an offense when .length is used' do
    expect_offense(<<~RUBY)
      x.length
        ^^^^^^ Crystal does not have the .length or .count methods as aliases to .size
    RUBY

    expect_correction(<<~RUBY)
      x.size
    RUBY
  end

  it 'registers an offense when &.length is used' do
    expect_offense(<<~RUBY)
      x&.length
         ^^^^^^ Crystal does not have the .length or .count methods as aliases to .size
    RUBY

    expect_correction(<<~RUBY)
      x&.size
    RUBY
  end

  it 'registers an offense when .count is used with no argument and no block' do
    expect_offense(<<~RUBY)
      x.count
        ^^^^^ Crystal does not have the .length or .count methods as aliases to .size
    RUBY

    expect_correction(<<~RUBY)
      x.size
    RUBY
  end

  it 'does not register an offense when .count is used with an argument and no block' do
    expect_no_offenses(<<~RUBY)
      x.count(y)
    RUBY
  end

  it 'does not register an offense when &.count is used with an argument and no block' do
    expect_no_offenses(<<~RUBY)
      x&.count(y)
    RUBY
  end

  it 'does not register an offense when .count is used with a block and no argument' do
    expect_no_offenses(<<~RUBY)
      x.count {|e| e > 2 }
    RUBY
  end

  it 'does not register an offense when .count is used with an argument and a block' do
    expect_no_offenses(<<~RUBY)
      x.count(y) {|e| e > 2 }
    RUBY
  end

  it 'does not register an offense when .size is used' do
    expect_no_offenses(<<~RUBY)
      x.size
    RUBY
  end
end
