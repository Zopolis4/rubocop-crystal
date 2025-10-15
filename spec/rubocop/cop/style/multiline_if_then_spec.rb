RSpec.describe RuboCop::Cop::Style::MultilineIfThen, :config do
  it 'registers an offense for then in multi-line if' do
    expect_offense(<<~RUBY)
      y = 7
      if true then
              ^^^^ Do not use `then` for multi-line `if`.
        y = -5
      end
      y
    RUBY

    expect_correction(<<~RUBY)
      y = 7
      if true
        y = -5
      end
      y
    RUBY

    expect_match_crystal
  end

  it 'registers an offense for then in multi-line unless' do
    expect_offense(<<~RUBY)
      x = 4
      unless true then
                  ^^^^ Do not use `then` for multi-line `unless`.
        x = 3
      end
      x
    RUBY

    expect_correction(<<~RUBY)
      x = 4
      unless true
        x = 3
      end
      x
    RUBY

    expect_match_crystal
  end
end
