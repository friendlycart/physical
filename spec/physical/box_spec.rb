# frozen_string_literal: true

RSpec.describe Physical::Box do
  subject { described_class.new(*args) }
  let(:args) { [[1, 2, 3], :cm] }

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
