# frozen_string_literal: true

require 'measured'

module Physical
  class Box < Cuboid
    DEFAULT_LENGTH = BigDecimal::INFINITY
    DEFAULT_MAX_WEIGHT = BigDecimal::INFINITY

    attr_reader :inner_dimensions,
                :inner_length,
                :inner_width,
                :inner_height,
                :max_weight

    def initialize(inner_dimensions: [], max_weight: Measured::Weight(DEFAULT_MAX_WEIGHT, :g), **args)
      super **args
      @inner_dimensions = fill_dimensions(Types::Dimensions[inner_dimensions])
      @inner_length, @inner_width, @inner_height = *@inner_dimensions
      @max_weight = Types::Weight[max_weight]
    end

    def inner_volume
      Measured::Volume(
        inner_dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*),
        :ml
      )
    end
  end
end
