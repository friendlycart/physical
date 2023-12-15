# frozen_string_literal: true

FactoryBot.define do
  factory :physical_structure, class: "Physical::Structure" do
    container { FactoryBot.build(:physical_pallet) }
    packages { build_list(:physical_package, 2) }
    initialize_with { new(**attributes) }
  end
end
