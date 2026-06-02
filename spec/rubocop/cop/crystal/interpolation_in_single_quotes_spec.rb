RSpec.describe RuboCop::Cop::Crystal::InterpolationInSingleQuotes, :config do
  it 'does not register an offense when a non-interpolated string is in double quotes' do
    expect_no_offenses(<<~RUBY)
      "foo"
    RUBY

    expect_match_crystal
  end

  it 'does not register an offense when an interpolated string is in double quotes' do
    expect_no_offenses(<<~'RUBY')
      "foo #{bar}"
    RUBY

    expect_match_crystal('bar = "qux"')
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

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an empty interpolated circle bracket pair is in single quotes' do
    expect_offense(<<~RUBY)
      '"()"'
      ^^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q("()")
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated circle bracket pair is in single quotes' do
    expect_offense(<<~RUBY)
      '"(frob)"'
      ^^^^^^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q("(frob)")
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated left circle bracket is in single quotes' do
    expect_offense(<<~RUBY)
      '"("'
      ^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q["("]
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated right circle bracket is in single quotes' do
    expect_offense(<<~RUBY)
      '")"'
      ^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q[")"]
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated left square bracket is in single quotes' do
    expect_offense(<<~RUBY)
      '"["'
      ^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q("[")
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated right square bracket is in single quotes' do
    expect_offense(<<~RUBY)
      '"]"'
      ^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q("]")
    RUBY

    expect_match_crystal('bar = "qux"')
  end

  it 'registers an offense when an interpolated pipe is in single quotes' do
    expect_offense(<<~RUBY)
      '"|"'
      ^^^^^ Crystal does not support the use of single-quote deliminated strings to avoid interpolation.
    RUBY

    expect_correction(<<~RUBY)
      %q("|")
    RUBY

    expect_match_crystal('bar = "qux"')
  end
end
