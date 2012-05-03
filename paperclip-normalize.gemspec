# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paperclip-normalize/version"

Gem::Specification.new do |s|
  s.name        = "paperclip-normalize"
  s.version     = '0.0.1'
  s.authors     = ["Zach Millman"]
  s.email       = ["zach.millman@gmail.com"]
  s.homepage    = "http://github.com/zmillman/paperclip-normalize"
  s.summary     = %q{Normalize the volume of your audio files}
  s.description = %q{Normalize the volume of your audio files}

  s.rubyforge_project = "paperclip-normalize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_dependency('paperclip')
end
