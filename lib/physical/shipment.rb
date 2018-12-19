# frozen_string_literal: true

module Physical
  class Shipment
    attr_reader :id,
                :origin,
                :destination,
                :service_code,
                :packages,
                :options

    def initialize(id: nil, origin: nil, destination: nil, service_code: nil, packages: [], options: {})
      @id = id || SecureRandom.uuid
      @origin = origin
      @destination = destination
      @service_code = service_code
      @packages = packages
      @options = options
    end
  end
end
