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
      @inner_length, @inner_width, @inner_height = *@inner_dimensions.reverse
    end

    alias :inner_x :inner_length
    alias :inner_y :inner_width
    alias :inner_z :inner_height
    alias :inner_depth :inner_height

    def inner_volume
      Measured::Volume(
        inner_dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*),
        :ml
      )
    end
  end
end
