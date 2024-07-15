require_relative 'harness'

Test.assert_equal 'foo', "foo"
Test.assert_equal 'foo'"bar", "foobar"
Test.assert_equal "foobar", "foo" + 'bar'

foo = 'bar'
Test.assert_equal '#{foo}', '#{foo}'
Test.assert_equal 'bar', "#{foo}"

Test.assert_unequal 'bar', '#{foo}'
Test.assert_unequal "#{foo}", '#{foo}'

Test.assert_equal '#{foo}'"bar", '#{foo}bar'
Test.assert_equal "#{foo}""bar", 'bar' + "bar"


Test.assert_unequal '#{1 + 1}', '2'

Test.assert_equal '#{foo}'"bar", '#{foo}bar'
