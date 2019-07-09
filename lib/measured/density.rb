# frozen_string_literal: true

require 'measured'

Measured::Density = Measured.build do
  si_unit :kg_m3, aliases: [
    :kilogram_per_cubic_meter,
    :kilogram_per_cubic_metre,
    :kilograms_per_cubic_meter,
    :kilograms_per_cubic_metre
  ]

  unit :g_ml, aliases: [
    :gram_per_milliliter,
    :gram_per_millilitre,
    :grams_per_milliliter,
    :grams_per_millilitre
  ], value: '1000 kg_m3'

  # UPS Freight classes use pound per cubic feet as density unit
  unit :lb_ft3, aliases: [
    :lbs_ft3,
    :pound_per_cubiq_foot,
    :pound_per_cubiq_feet,
    :pounds_per_cubiq_foot,
    :pounds_per_cubiq_feet
  ], value: '16.0184897305 kg_m3'
end
