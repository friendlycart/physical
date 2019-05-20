# frozen_string_literal: true

require 'measured'

module Physical
  class Cuboid
    attr_reader :dimensions, :length, :width, :height, :weight, :id, :properties

    def initialize(id: nil, dimensions: [], weight: nil, properties: {})
      @id = id || SecureRandom.uuid
      @weight = weight || Measured::Weight(0, :g)
      @dimensions = dimensions
      @dimensions.fill(Measured::Length(self.class::DEFAULT_LENGTH, :cm), @dimensions.length..2)
      @dimensions = dimensions.sort
      @length, @width, @height = *@dimensions.reverse
      @properties = properties
    end

    alias :x :length
    alias :y :width
    alias :z :height
    alias :depth :height

    def volume
      Measured::Volume(dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*), :ml)
    end

    def ==(other)
      id == other.id
    end
  end
end
