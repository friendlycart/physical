# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require "yardstick/rake/measurement"

Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = "/tmp/yard-results/measure.txt"
end

require "yardstick/rake/verify"
require "yaml"

options = YAML.load_file(".yardstick.yml")
Yardstick::Rake::Verify.new(:yardstick_verify, options)
