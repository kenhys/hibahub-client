# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yomou/version'

Gem::Specification.new do |spec|
  spec.name          = "yomou"
  spec.version       = Yomou::VERSION
  spec.authors       = ["Kentaro Hayashi"]
  spec.email         = ["kenhys@gmail.com"]
  spec.summary       = %q{Command line utility to fetch narou novels.}
  spec.description   = %q{Command line utility to fetch narou novels and manage favorite ones.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "extlz4", "~> 0.2"
  spec.add_runtime_dependency "feedjira", "~> 1.4.0"
  spec.add_runtime_dependency "mechanize", "~> 2.7.3"
  spec.add_runtime_dependency "rroonga", "~> 5.0.4"
  spec.add_runtime_dependency "ruby-xz", "~> 0.2.1"
  spec.add_runtime_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "stackprof"
  spec.add_development_dependency "test-unit"
end
