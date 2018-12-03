# frozen_string_literal: true
require 'measured'

module Physical
  class Box
    attr_reader :dimensions

    def initialize(dimensions: [], dimension_unit: :cm)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, dimension_unit) }
      @dimensions.fill(Measured::Length(BigDecimal::INFINITY, dimension_unit), @dimensions.length..2)
    end
  end
end
