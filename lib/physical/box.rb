# frozen_string_literal: true

require 'measured'

module Physical
  # Represents a physical box which items can be packed into.
  class Box < Cuboid
    # The default dimensions of this box when unspecified
    DEFAULT_LENGTH = BigDecimal::INFINITY

    # The default maximum weight of this box when unspecified
    DEFAULT_MAX_WEIGHT = BigDecimal::INFINITY

    # The inner length, width, and height of this box
    # @return [Array<Measured::Length>]
    attr_reader :inner_dimensions

    # The inner length of this box
    # @return [Measured::Length]
    attr_reader :inner_length

    # The inner width of this box
    # @return [Measured::Length]
    attr_reader :inner_width

    # The inner height of this box
    # @return [Measured::Length]
    attr_reader :inner_height

    # The maximum weight this box can handle
    # @return [Measured::Weight]
    attr_reader :max_weight

    # @param [Hash] kwargs ID, dimensions, weight, and properties
    # @option kwargs [String] :id a unique identifier for this box
    # @option kwargs [Array<Measured::Length>] :dimensions the outer length, width, and height of this box
    # @option kwargs [Array<Measured::Length>] :inner_dimensions the inner length, width, and height of this box
    # @option kwargs [Measured::Weight] :weight the weight of the box itself (excluding what's inside)
    # @option kwargs [Measured::Weight] :max_weight the maximum weight this box can handle
    # @option kwargs [Hash] :properties additional custom properties for this box
    def initialize(**kwargs)
      inner_dimensions = kwargs.delete(:inner_dimensions) || []
      max_weight = kwargs.delete(:max_weight) || Measured::Weight(DEFAULT_MAX_WEIGHT, :g)
      super(**kwargs)
      @inner_dimensions = fill_dimensions(Types::Dimensions[inner_dimensions])
      @inner_length, @inner_width, @inner_height = *@inner_dimensions
      @max_weight = Types::Weight[max_weight]
    end

    # Calculates and returns this box's volume based on the inner dimensions
    # @return [Measured::Volume]
    def inner_volume
      Measured::Volume(
        inner_dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*),
        :ml
      )
    end

    # Returns true if the given item can fit inside this box
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
