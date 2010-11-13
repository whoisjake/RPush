require 'spec_helper'

describe RPush::Parser, '#tokenize' do
  it "tokenizes an input" do
    parser = RPush::Parser.new
    parser.tokenize("()").should == ["(",")"]
    parser.tokenize("(1 2 INTEGER.+)").should == ["(","1","2","INTEGER.+",")"]
  end
end

describe RPush::Parser, '#interpret' do
  it "interprets a set of tokens" do
    parser = RPush::Parser.new
    parser.interpret(parser.tokenize("()")).should == []
    parser.interpret(parser.tokenize("(1 2 INTEGER.+)")).should == atomize([1,2,"INTEGER.+"])
    parser.interpret(parser.tokenize("((1 2 INTEGER.+))")).should == atomize([[1,2,"INTEGER.+"]])
    parser.interpret(parser.tokenize("(1 (2.0) INTEGER.+)")).should == atomize([1,[2.0],"INTEGER.+"])
    parser.interpret(parser.tokenize("(1 (2.0 3.0 FLOAT.+) INTEGER.+)")).should == atomize([1,[2.0,3.0,"FLOAT.+"],"INTEGER.+"])
    parser.interpret(parser.tokenize("( 2 3 INTEGER.* 4.1 5.2 FLOAT.+ TRUE FALSE BOOLEAN.OR )")).should == atomize([2,3,"INTEGER.*",4.1,5.2,"FLOAT.+",true,false,"BOOLEAN.OR"])
  end
end