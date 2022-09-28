# frozen_string_literal: true

FactoryBot.define do
  factory :physical_item, class: "Physical::Item" do
    dimensions { [1, 2, 3].map { |d| Measured::Length(d, :cm) } }
    weight { Measured::Weight(50, :g) }
    initialize_with { new(**attributes) }
  end
end
