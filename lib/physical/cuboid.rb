# frozen_string_literal: true

require 'measured'

module Physical
  class Cuboid
    include PropertyReaders

    attr_reader :dimensions, :length, :width, :height, :weight, :id, :properties

    def initialize(id: nil, dimensions: [], weight: Measured::Weight(0, :g), properties: {})
      @id = id || SecureRandom.uuid
      @weight = Types::Weight[weight]
      @dimensions = []
      @dimensions = fill_dimensions(Types::Dimensions[dimensions])
      @length, @width, @height = *@dimensions
      @properties = properties
    end

    def volume
      Measured::Volume(dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*), :ml)
    end

    def density
      return Measured::Density(Float::INFINITY, :g_ml) if volume.value.zero?
      return Measured::Density(0.0, :g_ml) if volume.value.infinite?

      Measured::Density(weight.convert_to(:g).value / volume.convert_to(:ml).value, :g_ml)
    end

    def ==(other)
      other.is_a?(self.class) &&
        id == other&.id
    end

    private

    def fill_dimensions(dimensions)
      dimensions.fill(dimensions.length..2) do |index|
        @dimensions[index] || Measured::Length(self.class::DEFAULT_LENGTH, :cm)
      end
    end
  end
end
