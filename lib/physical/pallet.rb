# frozen_string_literal: true

require 'measured'

module Physical
  # Represents a physical pallet which holds boxes.
  class Pallet < Cuboid
    # The default dimensions of this pallet when unspecified
    DEFAULT_LENGTH = BigDecimal::INFINITY

    # The default maximum weight of this pallet when unspecified
    DEFAULT_MAX_WEIGHT = BigDecimal::INFINITY

    # The maximum weight this pallet can handle
    # @return [Measured::Weight]
    attr_reader :max_weight

    # @param [Hash] kwargs ID, dimensions, weight, and properties
    # @option kwargs [String] :id a unique identifier for this pallet
    # @option kwargs [Array<Measured::Length>] :dimensions the length, width, and height of this pallet
    # @option kwargs [Measured::Weight] :weight the weight of the pallet itself (excluding what's on top)
    # @option kwargs [Measured::Weight] :max_weight the maximum weight this pallet can handle
    # @option kwargs [Hash] :properties additional custom properties for this pallet
    def initialize(**kwargs)
      max_weight = kwargs.delete(:max_weight) || Measured::Weight(DEFAULT_MAX_WEIGHT, :g)
      super(**kwargs)
      @max_weight = Types::Weight[max_weight]
    end

    # @!method volume
    #   @return [Measured::Volume] the volume of this pallet
    alias_method :inner_volume, :volume

    # @!method dimensions
    #   @return [Array<Measured::Length>] the dimensions of this pallet
    alias_method :inner_dimensions, :dimensions

    # @!method length
    #   @return [Measured::Length] the length of this pallet
    alias_method :inner_length, :length

    # @!method width
    #   @return [Measured::Length] the width of this pallet
    alias_method :inner_width, :width

    # @!method height
    #   @return [Measured::Length] the height of this pallet
    alias_method :inner_height, :height

    # Returns true if the given package can fit on the pallet. Checks package
    # dimensions and weight against pallet dimensions and max weight.
    # @param [Physical::Package] package
    # @return [Boolean]
    def package_fits?(package)
      return false if package.weight > max_weight

      pallet_dimensions = dimensions.sort
      package.dimensions.sort.each.with_index do |axis, index|
        return false if axis >= pallet_dimensions.sort[index]
      end
      true
    end
  end
end
