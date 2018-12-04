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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.4'
  spec.add_runtime_dependency "carmen"
  spec.add_runtime_dependency "measured"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
