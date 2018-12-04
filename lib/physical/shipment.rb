# frozen_string_literal: true

module Physical
  class Shipment
    attr_reader :id,
                :origin,
                :destination,
                :shipping_method,
                :packages,
                :options

    def initialize(id: nil, origin: nil, destination: nil, shipping_method: nil, packages: [], options: {})
      @id = id || SecureRandom.uuid
      @origin = origin
      @destination = destination
      @shipping_method = shipping_method
      @packages = packages
      @options = options
    end
  end
end
