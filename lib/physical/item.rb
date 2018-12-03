# frozen_string_literal: true
require 'measured'

module Physical
  class Item
    attr_reader :dimensions

    def initialize(dimensions: [], unit: :cm)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, unit) }
      @dimensions.fill(Measured::Length(0, unit), @dimensions.length..2)
    end
  end
end
