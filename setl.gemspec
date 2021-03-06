# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'setl/version'

Gem::Specification.new do |spec|
  spec.name          = "setl"
  spec.version       = Setl::VERSION
  spec.authors       = ["Leonard Garvey"]
  spec.email         = ["lengarvey@gmail.com"]
  spec.summary       = %q{Simple Extract Transform & Load - setl}
  spec.description   = %q{Can you setl for a tool that barely provides anything?}
  spec.homepage      = "https://github.com/lengarvey/setl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match /examples/}
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
