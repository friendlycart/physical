# frozen_string_literal: true

module Physical
  class Package
    attr_reader :container, :items

    def initialize(container: Physical::Box.new, items: [])
      @container = container
      @items = Set.new
      items.each { |items| @items << item }
    end
  end
end
