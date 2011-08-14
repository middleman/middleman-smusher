# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-smusher/version"

Gem::Specification.new do |s|
  s.name        = "middleman-smusher"
  s.version     = Middleman::Smusher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Reynolds"]
  s.email       = ["me@tdreyno.com"]
  s.homepage    = "https://github.com/tdreyno/middleman-smusher"
  s.summary     = %q{Compress images in your Middleman project}
  s.description = %q{Compress images in your Middleman project}

  s.rubyforge_project = "middleman-smusher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("middleman", ["~> 2.0.0"])
  s.add_runtime_dependency("smusher", ["~> 0.4.8"])
end
