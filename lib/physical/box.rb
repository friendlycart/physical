# frozen_string_literal: true

require 'measured'

module Physical
  class Box < Cuboid
    DEFAULT_LENGTH = BigDecimal::INFINITY
  end
end
