# frozen_string_literal: true

RSpec.shared_examples 'a cuboid' do
  let(:args) { {dimensions: [1, 2, 3], dimension_unit: :cm} }

  it { is_expected.to be_a(Physical::Cuboid) }

  it "has dimensions as Measured::Length objects" do
    expect(subject.dimensions).to eq(
      [
        Measured::Length.new(1, :cm),
        Measured::Length.new(2, :cm),
        Measured::Length.new(3, :cm)
      ]
    )
  end
end
