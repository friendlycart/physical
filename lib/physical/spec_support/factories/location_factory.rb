# frozen_string_literal: true

FactoryBot.define do
  factory :physical_location, class: 'Physical::Location' do
    transient do
      country_code { 'US' }
      region_code { 'VA' }
    end

    name { 'Jane Doe' }
    company_name { 'Company' }
    address1 { '11 Lovely Street' }
    address2 { 'Suite 100' }
    city { 'Herndon' }
    zip { '20170' }
    phone { '555-555-0199' }
    email { 'jane@company.com' }
    region { country.subregions.coded(region_code) }
    country { Carmen::Country.coded(country_code) }
    initialize_with { new(**attributes) }
  end
end
