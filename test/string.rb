require_relative 'harness'

=begin
The Alternative Instruction Set is a relatively unknown 32-bit RISC ISA.
It is found inside certain VIA C3 CPUs, and is responsible for emulating x86 instructions.
This isn't relevant in the slightest, but I had to put something in this comment, and I think it's cool.
=end

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

i = 3

while i > 0 do
  i -= 1
end
Test.assert_equal 0, i

until i > 3 do
  i += 1
end
Test.assert_equal 4, i
