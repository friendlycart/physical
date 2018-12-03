# frozen_string_literal: true
require 'measured'

module Physical
  class Cuboid
    attr_reader :dimensions

    def initialize(dimensions: [], dimension_unit: :cm)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, dimension_unit) }
      @dimensions.fill(Measured::Length(self.class::DEFAULT_LENGTH, dimension_unit), @dimensions.length..2)
    end

    def volume
      Measured::Volume(
        dimensions.map { |dim| dim.convert_to(:cm) }.map(&:value).reduce(&:*),
        :ml
      )
    end
  end
end
