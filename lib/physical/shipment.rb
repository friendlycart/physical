# frozen_string_literal: true

module Physical
  class Shipment
    attr_reader :id,
                :origin,
                :destination,
                :service_code,
                :pallets,
                :packages,
                :options

    def initialize(id: nil, origin: nil, destination: nil, service_code: nil, pallets: [], packages: [], options: {})
      @id = id || SecureRandom.uuid
      @origin = origin
      @destination = destination
      @service_code = service_code
      @pallets = pallets
      @packages = packages
      @options = options
    end
  end
end
