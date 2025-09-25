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

  it 'does not register an offense when not using safe navigation' do
    expect_no_offenses(<<~RUBY)
      x.even?
    RUBY

    expect_match_crystal('x = 1')
  end
end
