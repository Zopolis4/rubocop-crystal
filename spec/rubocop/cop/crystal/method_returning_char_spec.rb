RSpec.describe RuboCop::Cop::Crystal::MethodReturningChar, :config do
  it 'registers an offense when .chars is used without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x.chars
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x.chars.map { |c| c.to_s }
    RUBY
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
      x.chars.each { |c| puts c}
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x.chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'registers an offense when .chars is used on a string literal in a chain ending in a block without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      "foo".chars.each { |c| puts c}
            ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      "foo".chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'registers an offense when .chars is used on a variable in a chain ending in a block without converting the elements of the array to strings' do
    expect_offense(<<~RUBY)
      x = "foo"
      x.chars.each { |c| puts c}
        ^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x = "foo"
      x.chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'registers an offense when .each_char is used without converting the character to a string' do
    expect_offense(<<~RUBY)
      x.each_char { |c| puts c }
        ^^^^^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
    RUBY

    expect_correction(<<~RUBY)
      x.each_char { |c| puts c.to_s }
    RUBY
  end

  it 'registers an offense when .each_char with a multiline block is used without converting each instance of the character to a string' do
    expect_offense(<<~RUBY)
      x.each_char do |c|
        ^^^^^^^^^ In Crystal, this method returns the Char type instead of a 1-character string.
        puts foo if c == y
        bar
        z << c
      end
    RUBY

    expect_correction(<<~RUBY)
      x.each_char do |c|
        puts foo if c.to_s == y
        bar
        z << c.to_s
      end
    RUBY
  end

  it 'does not register an an offense when .chars is used with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x.chars.map { |c| c.to_s }
    RUBY
  end

  it 'does not register an an offense when &.chars is used with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x&.chars.map { |c| c.to_s }
    RUBY
  end

  it 'does not register an offense when .chars is used in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x.chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'does not register an offense when .chars is used on a string literal in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      "foo".chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'does not register an offense when .chars is used on a variable in a chain ending in a block with converting the elements of the array to strings' do
    expect_no_offenses(<<~RUBY)
      x = "foo"
      x.chars.map { |c| c.to_s }.each { |c| puts c}
    RUBY
  end

  it 'does not register an offense when .each_char is used with converting the character to a string' do
    expect_no_offenses(<<~RUBY)
      x.each_char { |c| puts c.to_s }
    RUBY
  end

  it 'does not register an offense when .each_char with a multiline block is used with converting each instance of the character to a string' do
    expect_no_offenses(<<~RUBY)
      x.each_char do |c|
        puts foo if c.to_s == y
        bar
        z << c.to_s
      end
    RUBY
  end

  it 'does not register an offense when .each_char is used with no instances of the character' do
    expect_no_offenses(<<~RUBY)
      x.each_char { |c| puts x }
    RUBY
  end

  it 'does not register an offense when .each_char with a multiline block is used with no instances of the character' do
    expect_no_offenses(<<~RUBY)
      x.each_char do |c|
        puts x
        foo if y == z
      end
    RUBY
  end
end
