# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Measured::Density do
  it "has a SI unit" do
    expect(Measured::Density(1, :kg_m3).unit).to be_a(Measured::Unit)
  end

  it "has aliases" do
    expect(Measured::Density(1, :kg_m3).unit.aliases).to match_array [
      "kilogram_per_cubic_meter",
      "kilogram_per_cubic_metre",
      "kilograms_per_cubic_meter",
      "kilograms_per_cubic_metre"
    ]
  end

  it "can be converted to grams per milliliter" do
    expect(Measured::Density(1, :kg_m3).convert_to(:g_ml).value).to eq(0.001)
  end

  it "can be converted to grams per liter" do
    expect(Measured::Density(1, :kg_m3).convert_to(:g_l).value).to eq(1)
  end

  it "can be converted to pounds per cubic feet" do
    expect(Measured::Density(1, :kg_m3).convert_to(:lbs_ft3).value.to_f).to eq(0.062427857858281754)
  end
end
