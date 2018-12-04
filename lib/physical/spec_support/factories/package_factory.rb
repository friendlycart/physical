# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :physical_package, class: "Physical::Package" do
    container { FactoryBot.build(:physical_box) }
    items { build_list(:physical_item, 2) }
    void_fill_density { 0.01 }
    initialize_with { new(attributes) }
  end
end
