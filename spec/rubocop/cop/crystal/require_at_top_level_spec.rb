RSpec.describe RuboCop::Cop::Crystal::RequireAtTopLevel, :config do
  it 'registers an offense when require is inside a function' do
    expect_offense(<<~RUBY)
      def foo
        require 'bar'
        ^^^^^^^^^^^^^ Crystal does not allow require anywhere other than the top level.
      end
    RUBY
  end

  it 'registers an offense when require is inside a class' do
    expect_offense(<<~RUBY)
      class Foo
        require 'bar'
        ^^^^^^^^^^^^^ Crystal does not allow require anywhere other than the top level.
      end
    RUBY
  end

  it 'registers an offense when require is inside a module' do
    expect_offense(<<~RUBY)
      module Foo
        require 'bar'
        ^^^^^^^^^^^^^ Crystal does not allow require anywhere other than the top level.
      end
    RUBY
  end

  it 'does not register an offense when require is at the top level' do
    expect_no_offenses(<<~RUBY)
      require 'bar'
    RUBY
  end

  it 'does not register an offense when a funciton does not contain require' do
    expect_no_offenses(<<~RUBY)
      def foo
        bar
      end
    RUBY
  end
end
