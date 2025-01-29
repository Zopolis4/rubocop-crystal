RSpec.describe RuboCop::Cop::Crystal::MethodNameStartingWithUppercaseLetter, :config do
  it 'registers an offense when the first letter of a method name is capitalized' do
    expect_offense(<<~RUBY)
      def Foo
          ^^^ Method names must start with a lowecase letter in Crystal.
        bar
      end
    RUBY
  end

  it 'registers an offense when all the letters of a method name are capitalized' do
    expect_offense(<<~RUBY)
      def FOO
          ^^^ Method names must start with a lowecase letter in Crystal.
        bar
      end
    RUBY
  end

  it 'does not register an offense when the first letter of a method name is lowercase' do
    expect_no_offenses(<<~RUBY)
      def foo
        bar
      end
    RUBY
  end

  it 'does not register an offense when the first letter of a method name is lowercase regardless of the rest of the method name' do
    expect_no_offenses(<<~RUBY)
      def fOO
        bar
      end
    RUBY
  end
end
