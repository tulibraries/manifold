# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "categorizable" do
  let(:model) { described_class } # the class that includes the concern
  let(:category) { FactoryBot.create(:category) }
  let(:category2) { FactoryBot.create(:category, :with_image) }
  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:single_category) {
    factory_model.categories << category
    factory_model
  }
  let(:multiple_categories) {
    factory_model.categories << category
    factory_model.categories << category2
    factory_model
  }

  it "has a categories method" do
    expect(factory_model).to respond_to(:categories)
  end

  it "can have one category added to it" do
    expect { single_category }.not_to raise_error
  end

  it "can have multiple category added to it" do
    expect { multiple_categories }.not_to raise_error
  end


  context "when it has no categories" do
    it "the categories method returns an empty object" do
      expect(factory_model.categories).to be_empty
    end
  end

  context "when it has one categories" do
    it "the categories method returns an array with the expected category" do
      expect(single_category.categories).to include(category)
    end
  end

  context "when it has multiple categories" do
    it "the categories method returns an array with the expected categories" do
      expect(multiple_categories.categories).to include(category, category2)
    end

    it "throws an error if duplicate categories are added to an item" do
      expect {
        factory_model.categories << category
        factory_model.categories << category
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "when a category is deleted" do
    it "removes that category for an item's categories" do
      factory_model.categories << category
      category.destroy
      factory_model.reload
      expect(factory_model.categories).to match_array([])
    end

  end


end
