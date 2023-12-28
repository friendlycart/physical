# frozen_string_literal: true

module Physical
  # Represents a physical structure which has a container (pallet, skid, etc.) and packages.
  class Structure
    extend Forwardable

    # A unique identifier for this structure
    # @return [String]
    attr_reader :id

    # The container ({Pallet}) for this structure
    # @return [Physical::Cuboid]
    attr_reader :container

    # The packages contained by this structure
    # @return [Array<Physical::Package>]
    attr_reader :packages

    # The weight of the packages in this structure
    # @return [Measured::Weight]
    attr_reader :packages_weight

    # The total volume used by the packages in this structure
    # @return [Measured::Volume]
    attr_reader :used_volume

    # @param [String] id a unique identifier for this structure
    # @param [Physical::Cuboid] container the container ({Pallet}) for this structure
    # @param [Array<Physical::Package>] packages the packages contained by this structure
    # @param [Array<Measured::Length>] dimensions the length, width, and height of this structure's container
    # @param [Measured::Weight] weight the weight of this structure's container
    # @param [Hash] properties additional custom properties for this package's container
    def initialize(id: nil, container: nil, packages: [], dimensions: nil, weight: nil, properties: {})
      @id = id || SecureRandom.uuid
      @container = container || Physical::Pallet.new(dimensions: dimensions || [], weight: weight || Measured::Weight(0, :g), properties: properties)

      @packages = Set[*packages]
      @packages_weight = @packages.map(&:weight).reduce(Measured::Weight(0, :g), &:+)
      @used_volume = @packages.map(&:volume).reduce(Measured::Volume(0, :ml), &:+)
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

    # Adds a package to the structure.
    # @param [Physical::Package] other the package to add
    def <<(other)
      @packages.add(other)
      @packages_weight += other.weight
      @used_volume += other.volume
    end
    alias_method :add, :<<

    # Removes a package from the structure.
    # @param [Physical::Package] other the package to remove
    def >>(other)
      @packages.delete(other)
      @packages_weight -= other.weight
      @used_volume -= other.volume
    end
    alias_method :delete, :>>

    # Sums container weight and packages weight and returns the total.
    # @return [Measured::Weight]
    def weight
      container.weight + packages_weight
    end

    # Sums and returns the item cost from all packages in this structure.
    # Item cost is optional, therefore we only return a sum if *all* packages
    # return item cost. Otherwise, nil is returned.
    # @return [Money, nil]
    def packages_value
      packages_cost = packages.map(&:items_value)
      packages_cost.reduce(&:+) if packages_cost.compact.size == packages_cost.size
    end

    # Calculates and returns remaining volume in this structure.
    # @return [Measured::Volume]
    def remaining_volume
      container.inner_volume - used_volume
    end

    # Returns the density of this structure based on its volume and weight.
    # @return [Measured::Density]
    def density
      return Measured::Density(Float::INFINITY, :g_ml) if container.volume.value.zero?
      return Measured::Density(0.0, :g_ml) if container.volume.value.infinite?

      Measured::Density(weight.convert_to(:g).value / container.volume.convert_to(:ml).value, :g_ml)
    end
  end
end
