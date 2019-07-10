# frozen_string_literal: true

module Physical
  class Package
    extend Forwardable
    attr_reader :container, :items, :void_fill_density, :id

    def initialize(id: nil, container: nil, items: [], void_fill_density: Measured::Weight(0, :g), dimensions: nil, weight: nil, properties: {})
      @id = id || SecureRandom.uuid
      @void_fill_density = Types::Weight[void_fill_density]
      @container = container || Physical::Box.new(dimensions: dimensions || [], weight: weight || Measured::Weight(0, :g), properties: properties)
      @items = Set[*items]
    end

    delegate [:dimensions, :width, :length, :height, :properties] => :container

    def <<(item)
      @items.add(item)
    end
    alias_method :add, :<<

    def >>(item)
      @items.delete(item)
    end
    alias_method :delete, :>>

    def weight
      container.weight + items.map(&:weight).reduce(Measured::Weight(0, :g), &:+) + void_fill_weight
    end

    def remaining_volume
      container.inner_volume - items.map(&:volume).reduce(Measured::Volume(0, :ml), &:+)
    end

    def void_fill_weight
      return Measured::Weight(0, :g) if container.volume.value.infinite?

      Measured::Weight(void_fill_density.value * remaining_volume.value, void_fill_density.unit)
    end

    def density
      return Measured::Density(Float::INFINITY, :g_ml) if container.volume.value.zero?
      return Measured::Density(0.0, :g_ml) if container.volume.value.infinite?
      Measured::Density(weight.convert_to(:g).value / container.volume.convert_to(:ml).value, :g_ml)
    end
  end
end
