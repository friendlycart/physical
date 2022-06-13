# frozen_string_literal: true

require 'measured'

module Physical
  class Pallet < Cuboid
    DEFAULT_LENGTH = BigDecimal::INFINITY
    DEFAULT_MAX_WEIGHT = BigDecimal::INFINITY

    attr_reader :max_weight

    def initialize(max_weight: Measured::Weight(DEFAULT_MAX_WEIGHT, :g), **args)
      super(**args)
      @max_weight = Types::Weight[max_weight]
    end
  end
end
