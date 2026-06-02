RSpec.describe RuboCop::Cop::Crystal::KeywordBlockParameter, :config do
  it 'registers an offense when a Crystal keyword is used as a block parameter name' do
    expect_offense(<<~RUBY)
      x.any? { |lib| lib.even? }
                ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      x.any? { |chatoyant_lib| chatoyant_lib.even? }
    RUBY

    expect_match_crystal('x = [0]')
  end

  it 'registers an offense when a Crystal keyword is used as an array argument to a block' do
    expect_offense(<<~RUBY)
      x.any? { |*lib| lib.first.even? }
                 ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      x.any? { |*chatoyant_lib| chatoyant_lib.first.even? }
    RUBY

    expect_match_crystal('x = [0]')
  end

  it 'registers an offense when a Crystal keyword is used as a splat argument to a block' do
    expect_offense(<<~RUBY)
      x.any? { |lib, **fun| lib.even? || fun.first.nil? }
                ^^^ Crystal does not allow keywords as block parameter names.
                       ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      x.any? { |chatoyant_lib, **chatoyant_fun| chatoyant_lib.even? || chatoyant_fun.first.nil? }
    RUBY
  end

  it 'registers an offense when a Crystal keyword is used as a block parameter name for a block with multiple parameters' do
    expect_offense(<<~RUBY)
      x.each { |asm, car| asm.to_s.empty? && car.odd? }
                ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      x.each { |chatoyant_asm, car| chatoyant_asm.to_s.empty? && car.odd? }
    RUBY
  end

  it 'registers an offense when a Crystal keyword is used as block parameter name via multiple assignment' do
    expect_offense(<<~RUBY)
      foo { |(lib, bar)| puts lib; puts bar }
              ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      foo { |(chatoyant_lib, bar)| puts chatoyant_lib; puts bar }
    RUBY
  end

  it 'registers an offense when multiple Crystal keywords are used as block parameter names via multiple assignment' do
    expect_offense(<<~RUBY)
      foo { |(lib, fun)| puts lib; puts fun }
                   ^^^ Crystal does not allow keywords as block parameter names.
              ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      foo { |(chatoyant_lib, chatoyant_fun)| puts chatoyant_lib; puts chatoyant_fun }
    RUBY
  end

  it 'registers an offense when multiple Crystal keywords are used as block parameter names' do
    expect_offense(<<~RUBY)
      foo { |lib, fun| puts lib; puts fun }
                  ^^^ Crystal does not allow keywords as block parameter names.
             ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      foo { |chatoyant_lib, chatoyant_fun| puts chatoyant_lib; puts chatoyant_fun }
    RUBY
  end

  it 'does not register an offense when a non-keyword is used as a block parameter name' do
    expect_no_offenses(<<~RUBY)
      foo { |car| puts car }
    RUBY
  end

  it 'does not register an offense when a non-keyword containing a keyword is used as a block parameter name' do
    expect_no_offenses(<<~RUBY)
      foo { |beginning| puts beginning }
    RUBY
  end

  it 'does not register an offense when a block has no parameters' do
    expect_no_offenses(<<~RUBY)
      foo { puts car }
    RUBY
  end
end
