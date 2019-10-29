# frozen_string_literal: true

require 'money'

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :cost,
                :sku

    def initialize(cost: nil, sku: nil, **kwargs)
      @cost = cost
      @sku = sku
      super kwargs
    end
  end
end
