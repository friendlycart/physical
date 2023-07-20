# frozen_string_literal: true

RSpec.shared_examples 'has property readers' do
  subject(:instance) { described_class.new(**args) }

  describe "#properties" do
    subject(:properties) { instance.properties }

    let(:args) do
      {
        properties: { flammable: true }
      }
    end

    it { is_expected.to eq({ flammable: true }) }
  end

  describe "properties methods" do
    context "if method is a property" do
      let(:args) do
        {
          properties: { already_packaged: true }
        }
      end

      it "returns its value" do
        expect(instance.already_packaged).to be(true)
      end

      it { is_expected.to respond_to(:already_packaged?) }
    end

    context "if method is a string property" do
      let(:args) do
        {
          properties: { "already_packaged" => true }
        }
      end

      it "returns its value" do
        expect(instance.already_packaged).to be(true)
      end

      it { is_expected.to respond_to(:already_packaged?) }
    end

    context "if method is a boolean property" do
      let(:args) do
        {
          properties: { already_packaged: true }
        }
      end

      it "it is also accessible by its predicate method" do
        expect(instance.already_packaged?).to be(true)
      end

      it { is_expected.to respond_to(:already_packaged?) }

      context "with a falsey value" do
        let(:args) do
          {
            properties: { already_packaged: false }
          }
        end

        it "returns its value" do
          expect(instance.already_packaged).to be(false)
        end
      end
    end

    context "if method is not a property" do
      let(:args) do
        {
          properties: {}
        }
      end

      it "raises method missing" do
        expect { instance.already_packaged? }.to raise_error(NoMethodError)
      end

      it { is_expected.not_to respond_to(:already_packaged?) }
    end
  end
end
