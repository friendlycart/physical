# frozen_string_literal: true

require 'carmen'

module Physical
  # Represents a physical location.
  class Location
    include PropertyReaders

    # Possible address types for this location
    ADDRESS_TYPES = %w(residential commercial po_box).freeze

    # This location's country
    # @return [Carmen::Country]
    attr_reader :country

    # This location's postal code
    # @return [String]
    attr_reader :zip

    # This location's state or province
    # @return [Carmen::Region]
    attr_reader :region

    # This location's city
    # @return [String]
    attr_reader :city

    # This location's name (could be a person's name)
    # @return [String]
    attr_reader :name

    # This location's address line 1
    # @return [String]
    attr_reader :address1

    # This location's address line 2
    # @return [String]
    attr_reader :address2

    # This location's address line 3
    # @return [String]
    attr_reader :address3

    # This location's phone
    # @return [String]
    attr_reader :phone

    # This location's fax
    # @return [String]
    attr_reader :fax

    # This location's email
    # @return [String]
    attr_reader :email

    # This location's address type (see {ADDRESS_TYPES})
    # @return [String]
    attr_reader :address_type

    # This location's company name
    # @return [String]
    attr_reader :company_name

    # This location's latitude
    # @return [String]
    attr_reader :latitude

    # This location's longitude
    # @return [String]
    attr_reader :longitude

    # Additional custom properties for this location
    # @return [String]
    attr_reader :properties

    # @param [String] name the name of this location (could be a person's name)
    # @param [String] company_name the name of the company at this location
    # @param [String] address1 the first line of the address
    # @param [String] address2 the second line of the address
    # @param [String] address3 the third line of the address
    # @param [String] city the city
    # @param [String, Carmen::Region] region the state or province
    # @param [String] zip the postal code
    # @param [String, Carmen::Country] country the country
    # @param [String] phone the phone number
    # @param [String] fax the fax number
    # @param [String] email the email address
    # @param [String] address_type the type of address (see {ADDRESS_TYPES})
    # @param [String] latitude the latitude at this location
    # @param [String] longitude the longitude at this location
    # @param [Hash] properties additional custom properties for this location
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
      address_type: nil,
      latitude: nil,
      longitude: nil,
      properties: {}
    )

      @country = if country.is_a?(Carmen::Country)
                   country
                 else
                   Carmen::Country.coded(country.to_s)
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
      @latitude = latitude
      @longitude = longitude
      @properties = properties
    end

    # Returns true if this location's address type is "residential"
    # @return [Boolean]
    def residential?
      @address_type == 'residential'
    end

    # Returns true if this location's address type is "commercial"
    # @return [Boolean]
    def commercial?
      @address_type == 'commercial'
    end

    # Returns true if this location's address type is "po_box"
    # @return [Boolean]
    def po_box?
      @address_type == 'po_box'
    end

    # Returns a hash representation of this location.
    # @return [Hash]
    def to_hash
      {
        country: country&.code,
        postal_code: zip,
        region: region&.code,
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

    # Returns true if the given object's class and {#to_hash} match this location.
    # @return [Boolean]
    def ==(other)
      other.is_a?(self.class) &&
        to_hash == other&.to_hash
    end
  end
end
