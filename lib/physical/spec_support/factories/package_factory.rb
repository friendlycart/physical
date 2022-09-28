# frozen_string_literal: true

FactoryBot.define do
  factory :physical_package, class: "Physical::Package" do
    container { FactoryBot.build(:physical_box) }
    items { build_list(:physical_item, 2) }
    void_fill_density { Measured::Density(0.01, :g_ml) }
    initialize_with { new(**attributes) }
  end
end
