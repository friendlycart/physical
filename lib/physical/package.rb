# frozen_string_literal: true

module Physical
  class Package
    attr_reader :container, :items

    def initialize(container: Physical::Box.new, items: [])
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
      container.weight + items.map(&:weight).sum
    end
  end
end
