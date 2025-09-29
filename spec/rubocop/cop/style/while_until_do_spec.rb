RSpec.describe RuboCop::Cop::Style::WhileUntilDo, :config do
  it 'registers an offense for do in multi-line while' do
    expect_offense(<<~RUBY)
      x = 4
      while x.positive? do
                        ^^ Do not use `do` with multi-line `while`.
        x -= 1
      end
      x
    RUBY

    expect_correction(<<~RUBY)
      x = 4
      while x.positive?
        x -= 1
      end
      x
    RUBY

    expect_match_crystal
  end

  it 'registers an offense for do in multi-line until' do
    expect_offense(<<~RUBY)
      y = -3
      until y == 1 do
                   ^^ Do not use `do` with multi-line `until`.
        y += 1
      end
      y
    RUBY

    expect_correction(<<~RUBY)
      y = -3
      until y == 1
        y += 1
      end
      y
    RUBY

    expect_match_crystal
  end
end
