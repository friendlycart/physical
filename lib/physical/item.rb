# frozen_string_literal: true

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :cost,
                :sku,
                :description

    def initialize(cost: nil, sku: nil, description: nil, **kwargs)
      @cost = Types::Money.optional[cost]
      @sku = sku
      @description = description
      super(**kwargs)
    end
  end
end
