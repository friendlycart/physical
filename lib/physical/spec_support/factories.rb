# frozen_string_literal: true

Alchemy::Deprecation.warn <<~MSG
  Please require factories using FactoryBots preferred approach:

      # spec/rails_helper.rb

      require 'physical/test_support'

      FactoryBot.definition_file_paths.concat(Physical::TestSupport.factory_paths)
      FactoryBot.reload
MSG

require 'physical/spec_support/factories/item_factory'
require 'physical/spec_support/factories/box_factory'
require 'physical/spec_support/factories/package_factory'
require 'physical/spec_support/factories/location_factory'
require 'physical/spec_support/factories/shipment_factory'
