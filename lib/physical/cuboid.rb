# frozen_string_literal: true

require 'measured'

module Physical
  # Represents a cube-shaped physical object with dimensions and weight.
  class Cuboid
    include PropertyReaders

    # A unique identifier for this cuboid
    # @return [String]
    attr_reader :id

    # The length, width, and height of this cuboid
    # @return [Array<Measured::Length>]
    attr_reader :dimensions

    # The length of this cuboid
    # @return <Measured::Length>
    attr_reader :length

    # The width of this cuboid
    # @return <Measured::Length>
    attr_reader :width

    # The height of this cuboid
    # @return <Measured::Length>
    attr_reader :height

    # The weight of the cuboid itself (excluding what's inside)
    # @return [Measured::Weight]
    attr_reader :weight

    # Additional custom properties for this cuboid
    # @return [Hash]
    attr_reader :properties

    # @param [String] id a unique identifier for this cuboid
    # @param [Array<Measured::Length>] dimensions the length, width, and height of this cuboid
    # @param [Measured::Weight] weight the weight of the cuboid itself (excluding what's inside)
    # @param [Hash] properties additional custom properties for this cuboid
    def initialize(id: nil, dimensions: [], weight: Measured::Weight(0, :g), properties: {})
      @id = id || SecureRandom.uuid
      @weight = Types::Weight[weight]
      @dimensions = []
      @dimensions = fill_dimensions(Types::Dimensions[dimensions])
      @length, @width, @height = *@dimensions
      @properties = properties
    end

    # Calculates and returns this cuboid's volume based on its dimensions.
    # @return [Measured::Volume]
    def volume
      Measured::Volume(dimensions.map { |d| d.convert_to(:cm).value }.reduce(1, &:*), :ml)
    end

    # Calculates and returns this cuboid's density based on its volume and weight.
    # @return [Measured::Density]
    def density
      return Measured::Density(Float::INFINITY, :g_ml) if volume.value.zero?
      return Measured::Density(0.0, :g_ml) if volume.value.infinite?

      Measured::Density(weight.convert_to(:g).value / volume.convert_to(:ml).value, :g_ml)
    end

    # Returns true if the given object shares the same class and ID with this cuboid.
    # @param [Object] other
    # @return [Boolean]
    def ==(other)
      other.is_a?(self.class) &&
        id == other&.id
    end

    private

    # Fills an array with dimensions or with default values if unspecified.
    # @param [Array<Measured::Length>] dimensions
    # @return [Array<Measured::Length>]
    def fill_dimensions(dimensions)
      dimensions.fill(dimensions.length..2) do |index|
        @dimensions[index] || Measured::Length(self.class::DEFAULT_LENGTH, :cm)
      end
    end
  end
end
