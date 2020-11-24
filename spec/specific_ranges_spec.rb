require "spec_helper"

describe "Specific Ranges for Bin, Softbin and Numbers" do

  before :each do
    TestIds.send(:reset)
  end

  def configs
    [:p1,:p2,:f1]
  end
  
  def a(name, options = {})
    TestIds.current_configuration.allocator.allocate(name, options)
    options
  end

  it "Ranges can be used to assign bins, softbins and numbers in the same configuration" do
    TestIds.configure do |config|
      config.bins do |options|
       if options[:bin_range].is_a?(Range)
        TestIds.next_in_range(options[:bin_range], options)
       end
     end 

      config.softbins do |options|
       if options[:softbin_range].is_a?(Range)
        TestIds.next_in_range(options[:softbin_range], options)
       end
      end

      config.numbers do |options|
       if options[:number_range].is_a?(Range)
        TestIds.next_in_range(options[:number_range], options)
       end
      end 

    a(:t1, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:bin].should == 10 
    a(:t2, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:bin].should == 11
    a(:t3, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:bin].should == 12
    a(:t4, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:bin].should == 13


    a(:t1, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:softbin].should == 100
    a(:t2, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:softbin].should == 101
    a(:t3, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:softbin].should == 102
    a(:t4, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:softbin].should == 103


    a(:t1, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:number].should == 1 
    a(:t2, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:number].should == 2
    a(:t3, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:number].should == 3
    a(:t4, bin_range: (10..13), softbin_range: (100..103),number_range: (1..4))[:number].should == 4
   end
  end

   it "Ranges can be used to assign test numbers" do
    TestIds.configure do |config|
      config.bins.include << (1..4)
      config.softbins.include << (500..600)
      config.numbers do |options|

       if options[:number_range].is_a?(Range)
        TestIds.next_in_range(options[:number_range], options)
       end
     end 

    a(:t1, number_range: (1..4))[:number].should == 1
    a(:t2, number_range: (1..4))[:number].should == 2
    a(:t3, number_range: (1..4))[:number].should == 3
    a(:t4, number_range: (1..4))[:number].should == 4
   end
  end

   it "Ranges can be used to assign bins" do
    TestIds.configure do |config|
      config.bins do |options|
       if options[:bin_range].is_a?(Range)
        TestIds.next_in_range(options[:bin_range], options)
       end
     end 

    a(:t1, bin_range: (1..4))[:bin].should == 1
    a(:t2, bin_range: (1..4))[:bin].should == 2
    a(:t3, bin_range: (1..4))[:bin].should == 3
    a(:t4, bin_range: (1..4))[:bin].should == 4
   end
  end

  it "Softbin Ranges can be used to assign softbins" do
    TestIds.configure do |config|
      config.softbins do |options|
       if options[:softbin_range].is_a?(Range)
        TestIds.next_in_range(options[:softbin_range], options)
       end
     end 

      config.numbers = :sx

    a(:t1, bin: 10, softbin_range: (1..4))[:softbin].should == 1
    a(:t2, bin: 20, softbin_range: (1..4))[:softbin].should == 2
    a(:t3, bin: 30, softbin_range: (1..4))[:softbin].should == 3
    a(:t4, bin: 40, softbin_range: (1..4))[:softbin].should == 4
   end
 end

 it 'Multiple Softbin Ranges can be used to assign softbins' do
    TestIds.configure do |config|
      config.softbins do |options|
        TestIds.next_in_range(options[:softbin_range], options)
      end 

      config.numbers = :sx

      a(:t1, bin: 10, softbin_range: [(1..2),(4..5)])[:softbin].should == 1
      a(:t2, bin: 20, softbin_range: [(1..2),(4..5)])[:softbin].should == 2
      a(:t4, bin: 40, softbin_range: [(1..2),(4..5)])[:softbin].should == 4
      a(:t5, bin: 50, softbin_range: [(1..2),(4..5)])[:softbin].should == 5
    end
 end

 it 'Multiple Softbin Ranges with a mix of Range and Integer can be used to assign softbins' do
    TestIds.configure do |config|
      config.softbins do |options|
        TestIds.next_in_range(options[:softbin_range], options)
      end 

      config.numbers = :sx

      a(:t1, bin: 10, softbin_range: [(1..2),3,(4..5)])[:softbin].should == 1
      a(:t2, bin: 20, softbin_range: [(1..2),3,(4..5)])[:softbin].should == 2
      a(:t3, bin: 30, softbin_range: [(1..2),3,(4..5)])[:softbin].should == 3
      a(:t4, bin: 40, softbin_range: [(1..2),3,(4..5)])[:softbin].should == 4
      a(:t5, bin: 50, softbin_range: [(1..2),3,(4..5)])[:softbin].should == 5
    end
 end

 it 'Multiple Softbin Ranges with size declaration can be used to assign softbins' do
    TestIds.configure do |config|
      config.softbins do |options|
        TestIds.next_in_range(options[:softbin_range], size: 5)
      end 
      config.numbers = :ssxxx

      a(:t1, bin: 10, softbin_range: [(10..19),31,(41..51)])[:softbin].should == 10
      a(:t2, bin: 20, softbin_range: [(10..19),31,(41..51)])[:softbin].should == 15
      a(:t3, bin: 30, softbin_range: [(10..19),31,(41..51)])[:softbin].should == 31
      a(:t4, bin: 40, softbin_range: [(10..19),31,(41..51)])[:softbin].should == 41
      a(:t5, bin: 50, softbin_range: [(10..19),31,(41..51)])[:softbin].should == 46
    end
 end

 it 'Multiple Softbin Ranges with overlapping ranges will raise an ERROR' do
    TestIds.configure :my_config_name do |config|
      config.softbins do |options|
        TestIds.next_in_range(options[:softbin_range], options)
      end 
      config.numbers = :sx

      expect {
        a(:t1, bin: 10, softbin_range: [(1..3),(2..5)])[:softbin].should == 1
        a(:t2, bin: 20, softbin_range: [(1..3),(2..5)])[:softbin].should == 2
        a(:t3, bin: 30, softbin_range: [(1..3),(2..5)])[:softbin].should == 3
        a(:t4, bin: 40, softbin_range: [(1..3),(2..5)])[:softbin].should == 4
      }.to raise_error
    end
 end

 it 'Duplicate Softbin Ranges have been detected' do
    TestIds.configure do |config|
      config.softbins do |options|
        if options[:softbin_range].is_a?(Range)
          TestIds.next_in_range(options[:softbin_range], options)
        end
      end 

      config.numbers = :sx

      expect {
        a(:t1, bin: 10, softbin_range: [(1..2),(3..4),(3..4)])[:softbin].should == 1
      }.to raise_error
    end
 end

end
