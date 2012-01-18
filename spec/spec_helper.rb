require 'rspec'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rpush'

def atomize(list)
  atomized = []
  list.each do |item|
    if item.is_a? Fixnum
      atomized << RPush::Atom.new(:integer,item)
    elsif item.is_a? Float
      atomized << RPush::Atom.new(:float,item)
    elsif (item.is_a? TrueClass) || (item.is_a? FalseClass)
      atomized << RPush::Atom.new(:boolean,item)
    elsif item.is_a? String
      atomized << RPush::Instruction.new(:instruction,item)
    elsif item.is_a? Array
      atomized << atomize(item)
    else
      raise "Atom not recognized"
    end
  end
  atomized
end