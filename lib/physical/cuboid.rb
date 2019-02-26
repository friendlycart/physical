# frozen_string_literal: true

require 'measured'

module Physical
  class Cuboid
    attr_reader :dimensions, :width, :height, :depth, :weight, :id, :properties

    def initialize(id: nil, dimensions: [], dimension_unit: :cm, weight: 0, weight_unit: :g, properties: {})
      @id = id || SecureRandom.uuid
      @weight = Measured::Weight(weight, weight_unit)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, dimension_unit) }
      @dimensions.fill(Measured::Length(self.class::DEFAULT_LENGTH, dimension_unit), @dimensions.length..2)
      @width, @height, @depth = *@dimensions
      @properties = properties
    end

    def volume
      Measured::Volume(dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*), :ml)
    end

    def ==(other)
      id == other.id
    end
  end
end
