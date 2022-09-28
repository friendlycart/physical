# frozen_string_literal: true

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :cost,
                :sku,
                :description

    def initialize(**kwargs)
      @cost = Types::Money.optional[kwargs.delete(:cost)]
      @sku = kwargs.delete(:sku)
      @description = kwargs.delete(:description)
      super(**kwargs)
    end
  end
end
