# frozen_string_literal: true
require 'measured'

module Physical
  class Box
    attr_reader :dimensions

    def initialize(dimensions, unit)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, unit) }
    end
  end
end
