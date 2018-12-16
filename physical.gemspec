# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "physical/version"

Gem::Specification.new do |spec|
  spec.name          = "physical"
  spec.version       = Physical::VERSION
  spec.authors       = ["Martin Meyerhoff"]
  spec.email         = ["mamhoff@gmail.com"]

  spec.summary       = "A facade to deal with physical packages"
  spec.description   = "A package with boxes and items"
  spec.homepage      = "http://example.com"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.4'
  spec.add_runtime_dependency "carmen"
  spec.add_runtime_dependency "factory_bot"
  spec.add_runtime_dependency "measured"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
