# frozen_string_literal: true

module Physical
  # Represents a physical item which can be packed into a box.
  class Item < Cuboid
    # The default dimensions of this item when unspecified
    DEFAULT_LENGTH = 0

    # The cost for this item
    # @return [Money]
    attr_reader :cost

    # The SKU for this item
    # @return [String]
    attr_reader :sku

    # A description for this item
    # @return [String]
    attr_reader :description

    # @param [Hash] kwargs ID, dimensions, weight, and properties
    # @option kwargs [String] :id a unique identifier for this item
    # @option kwargs [Money] :cost the cost of this item
    # @option kwargs [String] :sku the SKU for this item
    # @option kwargs [String] :description a description for this item
    # @option kwargs [Array<Measured::Length>] :dimensions the length, width, and height of this item
    # @option kwargs [Measured::Weight] :weight the weight of this item
    # @option kwargs [Hash] :properties additional custom properties for this item
    def initialize(**kwargs)
      @cost = Types::Money.optional[kwargs.delete(:cost)]
      @sku = kwargs.delete(:sku)
      @description = kwargs.delete(:description)
      super(**kwargs)
    end
  end
end
