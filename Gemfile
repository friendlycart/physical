# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in physical.gemspec
gemspec

group :test do
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'simplecov', require: false
end
