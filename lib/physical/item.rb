# frozen_string_literal: true

module Physical
  class Item < Cuboid
    DEFAULT_LENGTH = 0

    attr_reader :properties

    def initialize(properties: {}, **args)
      @properties = properties
      super(args)
    end
  end
end
