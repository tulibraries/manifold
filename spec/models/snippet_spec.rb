# frozen_string_literal: true

require "rails_helper"

RSpec.describe Snippet, type: :model do
  describe "A basic snippet" do
    let(:snippet) { FactoryBot.build(:snippet, :no_description) }

    context "Validations" do
      it "raises an error when description is not present" do
        expect { snippet.save! }.to raise_error(/Description can't be blank/)
      end
    end
  end

  describe "#label" do
    let(:snippet) { FactoryBot.build(:snippet) }
    it "has a label with the title" do
      expect(snippet.label).to eq(snippet.title)
    end
  end
end
