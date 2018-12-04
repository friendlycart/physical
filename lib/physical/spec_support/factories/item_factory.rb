# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :physical_item, class: "Physical::Item" do
    dimensions { [1, 2, 3] }
    dimension_unit { :cm }
    weight { 50 }
    weight_unit { :g }
    initialize_with { new(attributes) }
  end
end
