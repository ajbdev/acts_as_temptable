# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'temptable/version'

Gem::Specification.new do |spec|
  spec.name          = "temptable"
  spec.version       = Temptable::VERSION
  spec.authors       = ["Andy Baird"]
  spec.email         = ["andy@threadsculture.com"]

  spec.summary       = "Use SQL temporary tables as ActiveRecord backends"
  spec.description   = "Generate temporary tables on the fly and use ActiveRecord to query against it"
  spec.homepage      = "https://github.com/ajbdev/act_as_temptable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
