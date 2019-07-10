require 'measured'
require 'dry-types'

module Physical
  module Types
    include Dry.Types

    Weight = Types.Instance(::Measured::Weight)
    Length = Types.Instance(::Measured::Length)
    Volume = Types.Instance(::Measured::Volume)
    Density = Types.Instance(::Measured::Density)

    Dimensions = Types::Strict::Array.of(Length)
  end
end
