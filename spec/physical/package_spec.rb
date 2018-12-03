# frozen_string_literal: true

RSpec.describe Physical::Package do
  subject { described_class.new(args) }

  context 'with no args given' do
    let(:args) { {} }

    it "has no items" do
      expect(subject.items).to be_empty
    end

    it "is an infitely large box" do
      expect(subject.container).to be_a(Physical::Box)
      expect(subject.container.dimensions).to eq(
        [Measured::Length.new(BigDecimal::INFINITY, :cm)] * 3
      )
    end
  end
end
