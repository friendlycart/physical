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

    def initialize(**args)
      inner_dimensions = args.delete(:inner_dimensions) || []
      max_weight = args.delete(:max_weight) || Measured::Weight(DEFAULT_MAX_WEIGHT, :g)
      super(**args)
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

    # @param [Physical::Item] item
    # @return [Boolean]
    def item_fits?(item)
      return false if item.weight > max_weight

      box_dimensions = inner_dimensions.sort
      item.dimensions.sort.each.with_index do |axis, index|
        return false if axis >= box_dimensions[index]
      end
      true
    end
  end
end
