# frozen_string_literal: true

require 'spec_helper'

describe 'The number allocator' do
  before :each do
    TestIds.send(:reset)
  end

  def a(name, options = {})
    TestIds.current_configuration.allocator.allocate(name, options)
    options
  end

  it 'is alive' do
    TestIds.configure do |config|
      config.numbers.include << 3
    end
    a(:t1)[:number].should == 3
  end

  it 'number numbers increment' do
    TestIds.configure do |config|
      config.numbers.include << (1..3)
    end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3)[:number].should == 3
  end

  it 'duplicate tests pick up the same number number' do
    TestIds.configure do |config|
      config.numbers.include << (1..3)
    end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t1)[:number].should == 1
    a(:t3)[:number].should == 3
  end

  it 'caller can override number number' do
    TestIds.configure do |config|
      config.numbers.include << (1..4)
    end
    a(:t1)[:number].should == 1
    a(:t2, number: 3)[:number].should == 3
  end

  it 'number assignments can be inhibited by passing :none' do
    TestIds.configure do |config|
      config.numbers.include << (1..4)
    end
    a(:t1)[:number].should == 1
    a(:t1, number: :none)[:number].should.nil?
  end

  it 'manually assigned numbers are reserved' do
    TestIds.configure do |config|
      config.numbers.include << (1..5)
    end
    a(:t1)[:number].should == 1
    a(:t2, number: 3)[:number].should == 3
    a(:t3)[:number].should == 2
    a(:t4)[:number].should == 4
    TestIds.allocate(:t1)[:number].should == 1
    TestIds.allocate(:t2, number: 3)[:number].should == 3
    TestIds.allocate(:t3)[:number].should == 2
    TestIds.allocate(:t5)[:number].should == 5
  end

  it 'excluded numbers are not used' do
    TestIds.configure do |config|
      config.numbers.include << (1..4)
      config.numbers.exclude << 3
    end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3)[:number].should == 4
  end

  it 'the system can be saved to a file and resumed' do
    TestIds.configure do |config|
      config.numbers.include << (1..4)
    end
    a(:t1)[:number].should == 1
    a(:t2, number: 3)[:number].should == 3

    # TestIds.allocator.save
    # TestIds.send(:reset)
    # TestIds.configure do |config|
    #  config.numbers.include << (1..4)
    # end
    a(:t3)[:number].should == 2
    a(:t4)[:number].should == 4
  end

  it 'previously assigned manual numbers are reclaimed next time' do
    TestIds.configure do |config|
      config.numbers.include << (1..4)
    end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3, number: 2)[:number].should == 2

    # TestIds.allocator.save
    # TestIds.send(:reset)
    # TestIds.configure do |config|
    #  config.numbers.include << (1..4)
    # end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 3
    a(:t3, number: 2)[:number].should == 2
  end

  it 'when all numbers are used they will be re-used oldest first' do
    TestIds.configure do |config|
      config.numbers.include << (1..3)
    end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3)[:number].should == 3
    a(:t4)[:number].should == 1
    a(:t4)[:number].should == 1
    a(:t5)[:number].should == 2

    # TestIds.send(:reset)
    # TestIds.configure do |config|
    #  config.numbers.include << (1..3)
    # end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3)[:number].should == 3
    a(:t1)[:number].should == 1 # More recent reference makes 2 the oldest
    a(:t6)[:number].should == 2

    # TestIds.allocator.save
    # TestIds.send(:reset)
    # TestIds.configure do |config|
    #  config.numbers.include << (1..3)
    # end
    a(:t1)[:number].should == 1
    a(:t2)[:number].should == 2
    a(:t3)[:number].should == 3
    a(:t1)[:number].should == 1 # More recent reference makes 2 the oldest
    a(:t7)[:number].should == 2
    a(:t8)[:number].should == 3
  end

  it 'the numbers can be generated from an algorithm' do
    TestIds.configure do |config|
      config.bins.include << (1..3)
      config.softbins.include << (500..600)
      config.numbers.algorithm = :bbbsss000
    end
    t = a(:t1)
    t[:bin].should == 1
    t[:softbin].should == 500
    t[:number].should == 1_500_000
    t = a(:t2)
    t[:bin].should == 2
    t[:softbin].should == 501
    t[:number].should == 2_501_000
    t = a(:t3)
    t[:bin].should == 3
    t[:softbin].should == 502
    t[:number].should == 3_502_000
  end

  it 'algorithm based numbers can include an increment counter' do
    TestIds.configure do |config|
      config.bins.include << 3
      config.softbins.include << 2
      config.numbers.algorithm = '5bbbsssx'
    end
    a(:t0)[:number].should == 50_030_020
    a(:t1)[:number].should == 50_030_021
    a(:t2)[:number].should == 50_030_022
    a(:t3)[:number].should == 50_030_023
    a(:t4)[:number].should == 50_030_024
    a(:t5)[:number].should == 50_030_025
    a(:t6)[:number].should == 50_030_026
    a(:t7)[:number].should == 50_030_027
    a(:t8)[:number].should == 50_030_028
    a(:t9)[:number].should == 50_030_029
    # Bump these up the reference table
    a(:t0)[:number].should == 50_030_020
    a(:t1)[:number].should == 50_030_021
    a(:t2)[:number].should == 50_030_022
    # The first duplicate
    a(:t10)[:number].should == 50_030_023
  end

  it 'the incremental counter can be leading' do
    TestIds.configure do |config|
      config.bins.include << 3
      config.softbins.include << 2000
      config.numbers.algorithm = 'xxxssss'
    end
    a(:t0)[:number].should == 2000
    a(:t1)[:number].should == 12_000
    a(:t2)[:number].should == 22_000
    a(:t3)[:number].should == 32_000
    a(:t2)[:number].should == 22_000
  end

  it 'the numbers can be generated from a callback' do
    TestIds.configure do |config|
      config.bins.include << (1..3)
      config.softbins.include << (500..600)
      config.numbers.callback do |options|
        options[:bin] + options[:softbin]
      end
    end
    t = a(:t1)
    t[:bin].should == 1
    t[:softbin].should == 500
    t[:number].should == 501
    t = a(:t2)
    t[:bin].should == 2
    t[:softbin].should == 501
    t[:number].should == 503
    t = a(:t3)
    t[:bin].should == 3
    t[:softbin].should == 502
    t[:number].should == 505
  end

  it 'tests can reserve multiple numbers' do
    TestIds.configure do |config|
      config.bins.include << 3
      config.softbins.include << 3
      config.numbers.include << (8000..10_000)
      config.numbers.size = 5
    end

    t = a(:t1)
    t[:number].should == 8000
    # Verify the pointer takes account of the size
    TestIds.current_configuration.allocator.store['pointers']['numbers'].should == 8004
    t = a(:t2)
    t[:number].should == 8005
  end
end
