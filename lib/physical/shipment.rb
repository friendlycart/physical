# frozen_string_literal: true

module Physical
  class Shipment
    attr_reader :id,
                :origin,
                :destination,
                :service_code,
                :pallets,
                :structures,
                :packages,
                :options

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
