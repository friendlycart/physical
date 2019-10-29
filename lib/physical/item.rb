# frozen_string_literal: true

require 'money'

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :cost

    def initialize(cost: nil, **kwargs)
      @cost = cost
      super kwargs
    end
  end
end
