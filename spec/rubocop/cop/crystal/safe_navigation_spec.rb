RSpec.describe RuboCop::Cop::Crystal::SafeNavigation, :config do
  it 'registers an offense when using safe navigation' do
    expect_offense(<<~RUBY)
      x&.even?
       ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      x.try &.even?
    RUBY

    expect_match_crystal('x = 2')
    expect_match_crystal('x = nil')
  end

  it 'registers an offense when using safe navigation at the start of a method chain' do
    expect_offense(<<~RUBY)
      x&.size.nil?
       ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      x.try &.size.nil?
    RUBY

    expect_match_crystal('x = [1, 5, 3, 1]')
    expect_match_crystal('x = nil')
  end

  it 'registers an offense when using safe navigation at the end of a method chain' do
    expect_offense(<<~RUBY)
      x.size&.even?
            ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      x.size.try &.even?
    RUBY

    expect_match_crystal('x = [3, 6, 2]')
  end

  it 'registers an offense when using safe navigation on a method on a local variable' do
    expect_offense(<<~RUBY)
      y = nil
      y&.length.nil?
       ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      y = nil
      y.try &.length.nil?
    RUBY
  end

  it 'registers an offense when using safe navigation on a method on an instance variable' do
    expect_offense(<<~RUBY)
      @y = nil
      @y&.length.nil?
        ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      @y = nil
      @y.try &.length.nil?
    RUBY
  end

  it 'registers an offense when using safe navigation on a method on a class variable' do
    expect_offense(<<~RUBY)
      @@y = nil
      @@y&.length.nil?
         ^^ Crystal has .try &. instead of &. for safe navigation.
    RUBY

    expect_correction(<<~RUBY)
      @@y = nil
      @@y.try &.length.nil?
    RUBY
  end

  it 'does not register an offense when not using safe navigation' do
    expect_no_offenses(<<~RUBY)
      x.even?
    RUBY

    expect_match_crystal('x = 1')
  end

  it 'does not register an offense when safe navigation has already been corrected' do
    expect_no_offenses(<<~RUBY)
      x.try &.even?
    RUBY
  end
end
