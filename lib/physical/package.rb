# frozen_string_literal: true

module Physical
  # Represents a physical package which has a container (box) and items.
  class Package
    extend Forwardable

    # A unique identifier for this package
    # @return [String]
    attr_reader :id

    # The container ({Box}) for this package
    # @return [Physical::Cuboid]
    attr_reader :container

    # The items contained by this package
    # @return [Array<Physical::Item>]
    attr_reader :items

    # The density of the void fill in this package
    # @return [Measured::Density]
    attr_reader :void_fill_density

    # The weight of the items in this package
    # @return [Measured::Weight]
    attr_reader :items_weight

    # The total volume used by the items in this package
    # @return [Measured::Volume]
    attr_reader :used_volume

    # The description for this package
    # @return [String]
    attr_reader :description

    # @param [String] id a unique identifier for this package
    # @param [Physical::Cuboid] container the container ({Box}) for this package
    # @param [Array<Physical::Item>] items the items contained by this package
    # @param [Measured::Density] void_fill_density the density of the void fill in this package
    # @param [Array<Measured::Length>] dimensions the length, width, and height of this package's container
    # @param [Measured::Weight] weight the weight of this package's container
    # @param [String] description a description for this package
    # @param [Hash] properties additional custom properties for this package's container
    def initialize(id: nil, container: nil, items: [], void_fill_density: Measured::Density(0, :g_ml), dimensions: nil, weight: nil, description: nil, properties: {})
      @id = id || SecureRandom.uuid
      @void_fill_density = Types::Density[void_fill_density]
      @container = container || Physical::Box.new(dimensions: dimensions || [], weight: weight || Measured::Weight(0, :g), properties: properties)
      @description = description

      @items = Set[*items]
      @items_weight = @items.map(&:weight).reduce(Measured::Weight(0, :g), &:+)
      @used_volume = @items.map(&:volume).reduce(Measured::Volume(0, :ml), &:+)
    end

    # @!attribute [r] dimensions
    #   The container's dimensions
    # @!attribute [r] weight
    #   The container's weight
    # @!attribute [r] length
    #   The container's length
    # @!attribute [r] height
    #   The container's height
    # @!attribute [r] properties
    #   The container's additional custom properties
    # @!attribute [r] volume
    #   The container's volume
    delegate [:dimensions, :width, :length, :height, :properties, :volume] => :container

    # Adds an item to the package.
    # @param [Physical::Item] other the item to add
    def <<(other)
      @items.add(other)
      @items_weight += other.weight
      @used_volume += other.volume
    end
    alias_method :add, :<<

    # Removes an item from the package.
    # @param [Physical::Item] other the item to remove
    def >>(other)
      @items.delete(other)
      @items_weight -= other.weight
      @used_volume -= other.volume
    end
    alias_method :delete, :>>

    # Sums container weight, items weight, and void fill weight and returns the total.
    # @return [Measured::Weight]
    def weight
      container.weight + items_weight + void_fill_weight
    end

    # Sums and returns the cost from all items in this package. Item cost is
    # optional, therefore we only return a sum if *all* items have a cost.
    # Otherwise, nil is returned.
    # @return [Money, nil]
    def items_value
      items_cost = items.map(&:cost)
      items_cost.reduce(&:+) if items_cost.compact.size == items_cost.size
    end

    # Calculates and returns the weight of the void fill in this package.
    # @return [Measured::Weight]
    def void_fill_weight
      return Measured::Weight(0, :g) if container.volume.value.infinite?

      Measured::Weight(void_fill_density.convert_to(:g_ml).value * remaining_volume.convert_to(:ml).value, :g)
    end

    # Calculates and returns remaining volume in this package.
    # @return [Measured::Volume]
    def remaining_volume
      container.inner_volume - used_volume
    end

    # Returns the density of this package based on its volume and weight.
    # @return [Measured::Density]
    def density
      return Measured::Density(Float::INFINITY, :g_ml) if container.volume.value.zero?
      return Measured::Density(0.0, :g_ml) if container.volume.value.infinite?

      Measured::Density(weight.convert_to(:g).value / container.volume.convert_to(:ml).value, :g_ml)
    end
  end
end
