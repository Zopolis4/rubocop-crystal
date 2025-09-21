RSpec.describe RuboCop::Cop::Crystal::FileReadLines, :config do
  it 'registers an offense when File.readlines is used with a path argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo")
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.read_lines("foo", chomp: false)
    RUBY
  end

  it 'registers an offense when IO.readlines is used with a path argument' do
    expect_offense(<<~RUBY)
      IO.readlines("foo")
         ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.read_lines("foo", chomp: false)
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path argument and chomp: false' do
    expect_offense(<<~RUBY)
      File.readlines("foo", chomp: false)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.read_lines("foo", chomp: false)
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path argument and chomp: true' do
    expect_offense(<<~RUBY)
      File.readlines("foo", chomp: true)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.read_lines("foo", chomp: true)
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path and a single-character separator argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", "a")
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line("a").to_a
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path and a multi-character separator argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", "quz")
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line("quz").to_a
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path and a nil separator argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", nil)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      [File.open("foo").each_line(chomp: false).to_a.join]
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path and an empty string separator argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", "")
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~'RUBY')
      File.open("foo").each_line("\n").to_a.join.split(/\n{2,}/).reject { |e| e.empty? }.reverse.map_with_index {|e, i| i == 0 ? e : "#{e}\n\n" }.reverse
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path and a limiter argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", 2)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line(2).to_a
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path, single-character separator, and limiter argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", "b", 3)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line("b", 3).to_a
    RUBY
  end

  it 'registers an offense when File.readlines is used with a path, multi-character separator, and limiter argument' do
    expect_offense(<<~RUBY)
      File.readlines("foo", "quz", 3)
           ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line("quz", 3).to_a
    RUBY
  end

  it 'registers an offense when .readlines is used on a File object' do
    expect_offense(<<~RUBY)
      File.open("foo").readlines
                       ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.open("foo").each_line.to_a
    RUBY
  end

  it 'registers an offense when .readlines is used on a chained File object' do
    expect_offense(<<~RUBY)
      File.new(File.expand_path("foo", "bar")).readlines
                                               ^^^^^^^^^ Ruby has IO.readlines, while Crystal has File.read_lines and IO.each_line
    RUBY

    expect_correction(<<~RUBY)
      File.new(File.expand_path("foo", "bar")).each_line.to_a
    RUBY
  end

  it 'does not register an offense when .readlines is used from a non File/IO class' do
    expect_no_offenses(<<~RUBY)
      Bar.readlines("foo")
    RUBY
  end

  it 'does not register an offense when .readlines is used on a non File/IO object' do
    expect_no_offenses(<<~RUBY)
      Bar.open("foo").readlines
    RUBY
  end
end
