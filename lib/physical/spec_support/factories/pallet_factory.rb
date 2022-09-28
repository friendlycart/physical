# frozen_string_literal: true

FactoryBot.define do
  factory :physical_pallet, class: "Physical::Pallet" do
    dimensions { [80, 120, 165].map { |d| Measured::Length(d, :cm) } }
    weight { Measured::Weight(22, :kg) }
    initialize_with { new(**attributes) }
  end
end
