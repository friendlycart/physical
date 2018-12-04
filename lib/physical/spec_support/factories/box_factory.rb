# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :physical_box, class: "Physical::Box" do
    dimensions { [4, 5, 6] }
    dimension_unit { :dm }
    weight { 0.1 }
    weight_unit { :kg }
    initialize_with { new(attributes) }
  end
end
