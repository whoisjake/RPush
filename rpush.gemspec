# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpush/version'

Gem::Specification.new do |s|
  s.name              = "rpush"
  s.version           = RPush::VERSION
  s.platform          = Gem::Platform::RUBY
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Language implementation of Push."
  s.homepage          = "http://github.com/whoisjake/rpush"
  s.email             = "jake@whoisjake.com"
  s.authors           = [ "Jake Good" ]
  s.has_rdoc          = false
  
  s.add_development_dependency "rake", "~> 10.0.0"
  s.add_development_dependency "rspec", "~> 2.13.0"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths = ["lib"]

  s.description       = <<desc
  Implements the Push genetic programming language with an interpreter and parser.
desc
end