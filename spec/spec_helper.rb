# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require "bundler/setup"
require "physical"
require "physical/spec_support/shared_examples"
require "factory_bot"
require "physical/test_support"

# Explicitly configure the default rounding mode to avoid deprecation warnings
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

FactoryBot.definition_file_paths.concat(Physical::TestSupport.factory_paths)
FactoryBot.reload

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
