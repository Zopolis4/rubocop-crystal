RSpec.describe RuboCop::Cop::Crystal::MethodReturningChar, :config do
  it 'registers an offense when .chars is used without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x.chars
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x.chars.map { |c| c.to_s }
    RUBY

    expect_match_crystal('x = "foo"')
  end

  it 'registers an offense when &.chars is used without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x&.chars
         ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x&.chars.map { |c| c.to_s }
    RUBY
  end

  it 'registers an offense when .chars is used in a chain ending in a block without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x.chars.map { |c| c.capitalize }
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x.chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal('x = "bar"')
  end

  it 'registers an offense when .chars is used on a string literal in a chain ending in a block without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      "foo".chars.map { |c| c.capitalize }
            ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      "foo".chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal('x = "qux"')
  end

  it 'registers an offense when .chars is used on a variable in a chain ending in a block without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x = "foo"
      x.chars.map { |c| c.capitalize }
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x = "foo"
      x.chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal
  end

  it 'registers an offense when .each_char is used without converting the character to a string' do
    expect_offense(<<~RUBY)
      y = ["foo", "bar"]
      x.each_char { |c| y << c }
        ^^^^^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
      y
    RUBY

    expect_correction(<<~RUBY)
      y = ["foo", "bar"]
      x.each_char { |c| y << c.to_s }
      y
    RUBY

    expect_match_crystal('x = "quuz"')
  end

  it 'registers an offense when .each_char with a multiline block is used without converting each instance of the character to a string' do
    expect_offense(<<~RUBY)
      z = ["foo", "bar"]
      x.each_char do |c|
        ^^^^^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
        z << "quz" if c == y
        true
        z << c
      end
      z
    RUBY

    expect_correction(<<~RUBY)
      z = ["foo", "bar"]
      x.each_char do |c|
        z << "quz" if c.to_s == y
        true
        z << c.to_s
      end
      z
    RUBY

    expect_match_crystal('x = "bbb"', 'y = "b"')
  end

  it 'does not register an an offense when .chars is used with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x.chars.map { |c| c.to_s }
    RUBY

    expect_match_crystal('x = "quuz"')
  end

  it 'does not register an an offense when &.chars is used with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x&.chars.map { |c| c.to_s }
    RUBY
  end

  it 'does not register an offense when .chars is used in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x.chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal('x = "quuz"')
  end

  it 'does not register an offense when .chars is used on a string literal in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      "foo".chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal
  end

  it 'does not register an offense when .chars is used on a variable in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x = "foo"
      x.chars.map { |c| c.to_s }.map { |c| c.capitalize }
    RUBY

    expect_match_crystal
  end

  it 'does not register an offense when .each_char is used with converting the character to a string' do
    expect_no_offenses(<<~RUBY)
      y = ["foo", "bar"]
      x.each_char { |c| y << c.to_s }
      y
    RUBY

    expect_match_crystal('x = "quuz"')
  end

  it 'does not register an offense when .each_char with a multiline block is used with converting each instance of the character to a string' do
    expect_no_offenses(<<~RUBY)
      z = ["foo", "bar"]
      x.each_char do |c|
        z << "quz" if c.to_s == y
        true
        z << c.to_s
      end
      z
    RUBY

    expect_match_crystal('x = "aaa"', 'y = "a"')
  end

  it 'does not register an offense when .each_char is used with no instances of the character' do
    expect_no_offenses(<<~RUBY)
      y = ["foo", "bar"]
      x.each_char { |c| y << "frob" }
      y
    RUBY

    expect_match_crystal('x = "quuz"')
  end

  it 'does not register an offense when .each_char with a multiline block is used with no instances of the character' do
    expect_no_offenses(<<~RUBY)
      z = ["foo", "bar"]
      x.each_char do |c|
        true
        z << "hat" if y == z
      end
      z
    RUBY

    expect_match_crystal('x = "quuz"', 'y = 4')
  end
end
