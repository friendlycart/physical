# frozen_string_literal: true

require 'carmen'

module Physical
  class Location
    ADDRESS_TYPES = %w(residential commercial po_box)

    attr_reader :country,
                :zip,
                :region,
                :city,
                :name,
                :address1,
                :address2,
                :address3,
                :phone,
                :fax,
                :email,
                :address_type,
                :company_name

    def initialize(
        name: nil,
        company_name: nil,
        address1: nil,
        address2: nil,
        address3: nil,
        city: nil,
        region: nil,
        zip: nil,
        country: nil,
        phone: nil,
        fax: nil,
        email: nil,
        address_type: nil
      )

      if country.is_a?(Carmen::Country)
        @country = country
      else
        @country = Carmen::Country.coded(country.to_s)
      end

      if region.is_a?(Carmen::Region)
        @region = region
      elsif @country.is_a?(Carmen::Country)
        @region = @country.subregions.coded(region.to_s.upcase)
      end

      @name = name
      @company_name = company_name
      @address1 = address1
      @address2 = address2
      @address3 = address3
      @city = city
      @zip = zip
      @phone = phone
      @fax = fax
      @email = email
      @address_type = address_type
    end

    def residential?
      @address_type == 'residential'
    end

    def commercial?
      @address_type == 'commercial'
    end

    def po_box?
      @address_type == 'po_box'
    end

    def to_hash
      {
        country: country.code,
        postal_code: zip,
        province: province.code,
        city: city,
        name: name,
        address1: address1,
        address2: address2,
        address3: address3,
        phone: phone,
        fax: fax,
        email: email,
        address_type: address_type,
        company_name: company_name
      }
    end

    def ==(other)
      to_hash == other.to_hash
    end
  end
end
