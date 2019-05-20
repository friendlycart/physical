# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :physical_box, class: "Physical::Box" do
    dimensions { [4, 5, 6].map { |d| Measured::Length(d, :dm) } }
    weight { Measured::Weight(0.1, :kg) }
    initialize_with { new(attributes) }
  end
end
