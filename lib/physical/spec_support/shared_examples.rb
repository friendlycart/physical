# frozen_string_literal: true

RSpec.shared_examples 'a cuboid' do
  let(:args) { {dimensions: [1.1, 2.2, 3.3], dimension_unit: :cm} }

  it { is_expected.to be_a(Physical::Cuboid) }

  it "has dimensions as Measured::Length objects with rational values" do
    expect(subject.dimensions).to eq(
      [
        Measured::Length.new(1.1, :cm),
        Measured::Length.new(2.2, :cm),
        Measured::Length.new(3.3, :cm)
      ]
    )
  end

  it "has getter methods for each dimension as Measured::Length object" do
    expect(subject.width).to eq(Measured::Length.new(1.1, :cm))
    expect(subject.height).to eq(Measured::Length.new(2.2, :cm))
    expect(subject.depth).to eq(Measured::Length.new(3.3, :cm))
  end
end