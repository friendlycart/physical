# frozen_string_literal: true

require 'factory_bot'
require_relative 'box_factory'
require_relative 'item_factory'

FactoryBot.define do
  factory :physical_package, class: "Physical::Package" do
    container { FactoryBot.build(:physical_box) }
    items { build_list(:physical_item, 2) }
    void_fill_density { Measured::Weight(0.01, :g) }
    initialize_with { new(attributes) }
  end
end
