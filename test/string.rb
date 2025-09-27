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

Test.assert_equal 'a'.chars[0], "a"
"bbb".each_char {|c| Test.assert_equal c, 'b' }

i = 3

while i > 0 do
  i -= 1
end
Test.assert_equal 0, i

until i > 3 do
  i += 1
end
Test.assert_equal 4, i

# TODO: This could be done using a true Tempfile, but Crystal removed theirs in https://github.com/crystal-lang/crystal/pull/6485.
File.write('temp', "first line\nsecond line\n\nfourth line\nfifth line")

Test.assert_equal File.readlines('temp'), ["first line\n", "second line\n", "\n", "fourth line\n", 'fifth line']
Test.assert_equal File.readlines('temp', chomp: true), ['first line', 'second line', '', 'fourth line', 'fifth line']
Test.assert_equal File.readlines('temp', ''), ["first line\nsecond line\n\n", "fourth line\nfifth line"]
Test.assert_equal File.readlines('temp', nil), ["first line\nsecond line\n\nfourth line\nfifth line"]
Test.assert_equal File.readlines('temp', 't'), ['first', " line\nsecond line\n\nfourt", "h line\nfift", 'h line']
Test.assert_equal File.readlines('temp', 'fi'), ['fi', "rst line\nsecond line\n\nfourth line\nfi", 'fth line']
Test.assert_equal File.readlines('temp', 7), ['first l', "ine\n", 'second ', "line\n", "\n", 'fourth ', "line\n", 'fifth l', 'ine']
# TODO: These are waiting on https://github.com/crystal-lang/crystal/issues/16134.
# Technically, we could fix the single-character separator by converting it to a Char, but that obviously won't work for the multi-character one, so we need to wait regardless.
# Test.assert_equal File.readlines('temp', 'e', 10), ['first line', "\nse", 'cond line', "\n\nfourth l", 'ine', "\nfifth lin", 'e']
# Test.assert_equal File.readlines('temp', 'li', 4), ["firs", "t li", "ne\ns", "econ", "d li", "ne\n\n", "four", "th l", "ine\n", "fift", 'h li', 'ne']

File.delete('temp')
