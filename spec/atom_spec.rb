require 'spec_helper'

describe RPush::Atom, '#new' do
  it "should create a valid integer instance" do
    atom = RPush::Atom.new(:integer,0)
    atom.type.should == :integer
    atom.value.should == 0
  end
end

describe RPush::Atom, '#eql?' do
  it "should show signs of equality" do
    oneA = RPush::Atom.new(:integer,1)
    oneB = RPush::Atom.new(:integer,1)
    
    oneA.should_not eql 1
    oneA.should eql oneB
    oneA.should == oneB
    oneA.should_not equal oneB
  end
end