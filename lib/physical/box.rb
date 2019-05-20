# frozen_string_literal: true

require 'measured'

module Physical
  class Box < Cuboid
    DEFAULT_LENGTH = BigDecimal::INFINITY
    attr_reader :inner_dimensions

    def initialize(inner_dimensions: [], **args)
      super args
      @inner_dimensions = fill_dimensions(inner_dimensions)
    end
  end
end
