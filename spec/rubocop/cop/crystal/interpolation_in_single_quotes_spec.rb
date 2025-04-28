RSpec.describe RuboCop::Cop::Crystal::InterpolationInSingleQuotes, :config do
  it 'does not register an offense when a non-interpolated string is in double quotes' do
    expect_no_offenses(<<~RUBY)
      "foo"
    RUBY
  end

  it 'does not register an offense when an interpolated string is in double quotes' do
    expect_no_offenses(<<~'RUBY')
      "foo #{bar}"
    RUBY
  end

  it 'does not register an offense when a non-interpolated string is in single quotes' do
    expect_no_offenses(<<~RUBY)
      'foo'
    RUBY
  end

  it 'registers an offense when an interpolated string is in single quotes' do
    expect_offense(<<~'RUBY')
      'foo #{bar}'
      ^^^^^^^^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~'RUBY')
      %q(foo #{bar})
    RUBY
  end
end
