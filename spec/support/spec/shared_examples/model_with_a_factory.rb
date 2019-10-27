RSpec.shared_examples 'model with a factory' do |*args|
  with_args = args.size > 0 ? " #{args.inspect}" : nil    # => " [:with_ratings]" or something.

  it "is creatable#{with_args}" do
    # 2 times isn't many, but will help notice trivial factory glitches.
    2.times { create me, *args }
  end

  it "is saveable right after `build`#{with_args}" do
    2.times { expect_save_ok(build me, *args) }
  end
end