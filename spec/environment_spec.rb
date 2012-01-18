require 'spec_helper'

describe RPush::Environment, '#initialize' do
  it "should create a set of default operations" do
    env = RPush::Environment.new
    env.operations.keys.should =~ [:integer,:float,:boolean,:name,:code,:exec]
  end
end

describe RPush::Environment, '#push' do
  it "pushes values onto named stacks" do
    env = RPush::Environment.new
    env.push(:test,"value")
    env.stacks[:test].should =~ ["value"]
  end
end

describe RPush::Environment, '#apply' do
  it "applies an operation to the environment" do
    env = RPush::Environment.new
    env.should_receive(:pop).twice.and_return(2)
    env.should_receive(:size_of).once.with(:integer).and_return(2)
    env.should_receive(:push).once.with(:integer,4)
    env.apply(RPush::Instruction.new(:instruction,"INTEGER.+"))
  end
end