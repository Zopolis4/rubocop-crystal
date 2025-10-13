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

  it 'registers an offense when a Crystal keyword is used as a block parameter name for a block with multiple parameters' do
    expect_offense(<<~RUBY)
      x.each { |asm, car| asm.to_s.empty? && car.odd? }
                ^^^ Crystal does not allow keywords as block parameter names.
    RUBY

    expect_correction(<<~RUBY)
      x.each { |chatoyant_asm, car| chatoyant_asm.to_s.empty? && car.odd? }
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

  it 'does not register an offense when a block has no parameters' do
    expect_no_offenses(<<~RUBY)
      foo { puts car }
    RUBY
  end
end
