# frozen_string_literal: true

FactoryBot.define do
  factory :physical_box, class: "Physical::Box" do
    dimensions { [20, 15, 30].map { |d| Measured::Length(d, :cm) } }
    inner_dimensions { dimensions.map { |d| d - Measured::Length(1, :cm) } }
    weight { Measured::Weight(0.1, :kg) }
    initialize_with { new(**attributes) }
  end
end
