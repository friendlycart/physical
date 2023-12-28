# frozen_string_literal: true

module Physical
  # Represents a physical shipment containing structures and/or packages.
  class Shipment
    # A unique identifier for this shipment
    # @return [String]
    attr_reader :id

    # This shipment's origin location
    # @return [Physical::Location]
    attr_reader :origin

    # This shipment's destination location
    # @return [Physical::Location]
    attr_reader :destination

    # The shipment carrier's service code
    # @return [String]
    attr_reader :service_code

    # This shipment's pallets (DEPRECATED: use {#structures} instead)
    # @return [Array<Physical::Pallet>]
    attr_reader :pallets

    # This shipment's structures (pallets, skids, etc.) which hold packages
    # @return [Array<Physical::Structure>]
    attr_reader :structures

    # This shipment's packages which hold items
    # @return [Array<Physical::Package>]
    attr_reader :packages

    # Additional custom options for this shipment
    # @return [Hash]
    attr_reader :options

    # @param [String] id a unique identifier for this shipment
    # @param [Physical::Location] origin the shipment's origin location
    # @param [Physical::Location] destination the shipment's destination location
    # @param [String] service_code the shipment carrier's service code
    # @param [Array<Physical::Pallet>] pallets the shipment's pallets (DEPRECATED: use `structures` instead)
    # @param [Array<Physical::Structure>] structures the shipment's structures (pallets, skids, etc.) which hold packages
    # @param [Array<Physical::Package>] packages the shipment's packages (boxes) which hold items
    # @param [Hash] options additional custom options for this shipment
    def initialize(id: nil, origin: nil, destination: nil, service_code: nil, pallets: [], structures: [], packages: [], options: {})
      @id = id || SecureRandom.uuid
      @origin = origin
      @destination = destination
      @service_code = service_code
      @structures = structures
      @packages = packages
      @options = options
      @pallets = pallets
      warn "[DEPRECATION] `pallets` is deprecated.  Please use `structures` instead." if pallets.any?
    end
  end
end
