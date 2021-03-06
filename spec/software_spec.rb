require 'spec_helper'
require 'ronin/software'

describe Software do
  it "should require name and version attributes" do
    software = Software.new
    software.should_not be_valid

    software.name = 'Test'
    software.should_not be_valid

    software.version = '0.1.0'
    software.should be_valid
  end

  describe "#to_s" do
    it "should be convertable to a String" do
      software = Software.new(
        :name => 'Test', 
        :version => '0.1.0',
        :vendor => {:name => 'TestCo'}
      )

      software.to_s.should == 'TestCo Test 0.1.0'
    end

    it "should ignore the missing vendor information" do
      software = Software.new(:name => 'Test', :version => '0.1.0')

      software.to_s.should == 'Test 0.1.0'
    end
  end
end
