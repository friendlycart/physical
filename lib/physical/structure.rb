# frozen_string_literal: true

module Physical
  class Structure
    extend Forwardable
    attr_reader :id, :container, :packages, :packages_weight, :used_volume

    def initialize(id: nil, container: nil, packages: [], dimensions: nil, weight: nil, properties: {})
      @id = id || SecureRandom.uuid
      @container = container || Physical::Pallet.new(dimensions: dimensions || [], weight: weight || Measured::Weight(0, :g), properties: properties)

      @packages = Set[*packages]
      @packages_weight = @packages.map(&:weight).reduce(Measured::Weight(0, :g), &:+)
      @used_volume = @packages.map(&:volume).reduce(Measured::Volume(0, :ml), &:+)
    end

    delegate [:dimensions, :width, :length, :height, :properties, :volume] => :container

    def <<(other)
      @packages.add(other)
      @packages_weight += other.weight
      @used_volume += other.volume
    end
    alias_method :add, :<<

    def >>(other)
      @packages.delete(other)
      @packages_weight -= other.weight
      @used_volume -= other.volume
    end
    alias_method :delete, :>>

    def weight
      container.weight + packages_weight
    end

    # Cost is optional. We will only return an aggregate if all packages
    # have items value defined. Otherwise we will return nil.
    # @return Money
    def packages_value
      packages_cost = packages.map(&:items_value)
      packages_cost.reduce(&:+) if packages_cost.compact.size == packages_cost.size
    end

    def remaining_volume
      container.inner_volume - used_volume
    end

    def density
      return Measured::Density(Float::INFINITY, :g_ml) if container.volume.value.zero?
      return Measured::Density(0.0, :g_ml) if container.volume.value.infinite?

      Measured::Density(weight.convert_to(:g).value / container.volume.convert_to(:ml).value, :g_ml)
    end
  end
end
