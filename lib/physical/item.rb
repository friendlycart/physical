# frozen_string_literal: true

require 'money'

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :cost,
                :sku,
                :description

    def initialize(cost: nil, sku: nil, description: nil, **kwargs)
      @cost = cost
      @sku = sku
      @description = description
      super kwargs
    end
  end
end
