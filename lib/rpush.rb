require 'readline'
require 'rpush/extensions'

require 'rpush/version' unless defined?(RPush::Version)
require 'rpush/atom'
require 'rpush/operation'
require 'rpush/instruction'
require 'rpush/environment'
require 'rpush/parser'
require 'rpush/eval'

module RPush
  def self.repl
    parser = RPush::Parser.new
    loop do
      print '> '
      gets.each do | e |
        puts eval(parser.parse(e))
      end
    end
  end
end