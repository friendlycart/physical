# frozen_string_literal: true

FactoryBot.define do
  factory :physical_location, class: 'Physical::Location' do
    transient do
      country_code { 'US' }
      region_code { 'IL' }
    end

    name { 'Jane Doe' }
    company_name { 'Company' }
    address1 { '11 Lovely Street' }
    address2 { 'South' }
    city { 'Herndon' }
    sequence(:zip, 10001) { |i| i.to_s }
    phone { '555-555-0199' }
    region { country.subregions.coded(region_code) }
    country { Carmen::Country.coded(country_code) }
    initialize_with { new(attributes) }
  end
end
