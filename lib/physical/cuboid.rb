# frozen_string_literal: true

require 'measured'

module Physical
  class Cuboid
    attr_reader :dimensions, :weight, :id

    def initialize(id: nil, dimensions: [], dimension_unit: :cm, weight: 0, weight_unit: :g)
      @id = id || SecureRandom.uuid
      @weight = Measured::Weight(weight, weight_unit).convert_to(:g)
      @dimensions = dimensions.map { |dimension| Measured::Length.new(dimension, dimension_unit).convert_to(:cm) }
      @dimensions.fill(Measured::Length(self.class::DEFAULT_LENGTH, dimension_unit), @dimensions.length..2)
    end

    def volume
      Measured::Volume(dimensions.map(&:value).reduce(&:*), :ml)
    end

    def ==(other)
      id == other.id
    end
  end
end
