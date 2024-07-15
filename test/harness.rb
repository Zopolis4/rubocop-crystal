class Test
  @@failed_tests = 0
  @@passed_tests = 0

  def self.failed_tests
    @@failed_tests
  end

  def self.passed_tests
    @@passed_tests
  end

  def self.assert_equal(expected, actual)
    if expected == actual
      @@passed_tests += 1
    else
      @@failed_tests += 1
      puts "Assertion of equality failed:"
      puts "Expected: #{expected}"
      puts "Actual: #{actual}"
    end
  end

  def self.assert_unequal(expected, actual)
    if expected != actual
      @@passed_tests += 1
    else
      @@failed_tests += 1
      puts "Assertion of inequality failed:"
      puts "Expected: #{expected}"
      puts "Actual: #{actual}"
    end
  end
end

at_exit do
  puts "#{Test.passed_tests} tests passed."
  puts "#{Test.failed_tests} tests failed."
  exit(1) if Test.failed_tests.positive?
end

