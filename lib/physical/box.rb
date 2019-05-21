# frozen_string_literal: true

require 'measured'

module Physical
  class Box < Cuboid
    DEFAULT_LENGTH = BigDecimal::INFINITY
    attr_reader :inner_dimensions,
                :inner_length,
                :inner_width,
                :inner_height

    def initialize(inner_dimensions: [], **args)
      super args
      @inner_dimensions = fill_dimensions(Types::Dimensions[inner_dimensions])
      @inner_length, @inner_width, @inner_height = *@inner_dimensions
    end

    def inner_volume
      Measured::Volume(
        inner_dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*),
        :ml
      )
    end
  end
end
