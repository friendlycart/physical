require 'measured'
require 'dry-types'

module Physical
  module Types
    include Dry::Types.module

    Weight = Types.Instance(::Measured::Weight)
    Length = Types.Instance(::Measured::Length)
    Volume = Types.Instance(::Measured::Volume)

    Dimensions = Types::Strict::Array.of(Length)
  end
end
