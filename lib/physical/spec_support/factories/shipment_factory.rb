# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :physical_shipment, class: "Physical::Shipment" do
    origin { FactoryBot.build(:physical_location) }
    destination { FactoryBot.build(:physical_location) }
    packages { build_list(:physical_package, 2) }
    shipping_method { "USPS Priority" }
    initialize_with { new(attributes) }
  end
end
