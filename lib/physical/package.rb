# frozen_string_literal: true

module Physical
  class Package
    attr_reader :container, :items, :void_fill_density, :id

    def initialize(id: nil, container: Physical::Box.new, items: [], void_fill_density: 0, void_fill_density_unit: :g)
      @id = id || SecureRandom.uuid
      @void_fill_density = Measured::Weight(void_fill_density, void_fill_density_unit)
      @container = container
      @items = Set[*items]
    end

    def <<(item)
      @items.add(item)
    end

    def >>(item)
      @items.delete(item)
    end

    def weight
      container.weight + items.map(&:weight).sum + void_fill_weight
    end

    def remaining_volume
      container.volume - items.sum(&:volume)
    end

    def void_fill_weight
      return Measured::Weight(0, :g) if container.volume.value.infinite?
      Measured::Weight(void_fill_density.value * remaining_volume.value, void_fill_density.unit)
    end
  end
end
