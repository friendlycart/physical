# frozen_string_literal: true

require 'measured'

module Physical
  class Cuboid
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

    def ==(other)
      id == other.id
    end

    private

    NORMALIZED_METHOD_REGEX = /(\w+)\??$/

    def method_missing(method)
      symbolized_properties = properties.symbolize_keys
      method_name = normalize_method_name(method)
      if symbolized_properties.key?(method_name)
        symbolized_properties[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method, *args)
      method_name = normalize_method_name(method)
      properties.symbolize_keys.key?(method_name) || super
    end

    def normalize_method_name(method)
      method.to_s.sub(NORMALIZED_METHOD_REGEX, '\1').to_sym
    end

    def fill_dimensions(dimensions)
      dimensions.fill(dimensions.length..2) do |index|
        @dimensions[index] || Measured::Length(self.class::DEFAULT_LENGTH, :cm)
      end
    end
  end
end
