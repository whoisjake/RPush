# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpush'

Gem::Specification.new do |s|
  s.name              = "rpush"
  s.version           = RPush::Version.to_s
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Language implementation of Push."
  s.homepage          = "http://github.com/whoisjake/rpush"
  s.email             = "jake@whoisjake.com"
  s.authors           = [ "Jake Good" ]
  s.has_rdoc          = false

  s.files             = %w( README.markdown LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")

  s.executables       = %w( rpush )
  s.description       = <<desc
  Creates Gists (pastes) on gist.github.com from standard input or
  arbitrary files. Can link to your GitHub account, create private gists,
  and enable syntax highlighting.
desc
end