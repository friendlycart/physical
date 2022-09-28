# frozen_string_literal: true

FactoryBot.define do
  factory :physical_shipment, class: "Physical::Shipment" do
    origin { FactoryBot.build(:physical_location) }
    destination { FactoryBot.build(:physical_location) }
    packages { build_list(:physical_package, 2) }
    service_code { "usps_priority_mail" }
    initialize_with { new(**attributes) }
  end
end
