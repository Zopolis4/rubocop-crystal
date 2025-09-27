RSpec.describe RuboCop::Cop::Style::BlockComments, :config do
  it 'registers an offense on a block comment' do
    expect_offense(<<~RUBY)
      =begin
      ^^^^^^ Do not use block comments.
      The Alternative Instruction Set is a relatively unknown 32-bit RISC ISA.
      It is found inside certain VIA C3 CPUs, and is responsible for emulating x86 instructions.
      This isn't relevant in the slightest, but I had to put something in this comment, and I think it's cool.
      =end
    RUBY

    expect_correction(<<~RUBY)
      # The Alternative Instruction Set is a relatively unknown 32-bit RISC ISA.
      # It is found inside certain VIA C3 CPUs, and is responsible for emulating x86 instructions.
      # This isn't relevant in the slightest, but I had to put something in this comment, and I think it's cool.
    RUBY

    expect_match_crystal
  end
end
