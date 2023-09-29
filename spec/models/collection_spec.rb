# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection, type: :model do
  it_behaves_like "accountable"
  it_behaves_like "categorizable"
  it_behaves_like "imageable"

  describe "Required attributes" do

    example "Missing name" do
      collection = FactoryBot.build(:collection, name: "")
      expect { collection.save! }.to raise_error(/Name can't be blank/)
    end

    example "Missing description" do
      collection = FactoryBot.build(:collection, description: "")
      expect { collection.save! }.to_not raise_error
    end
  end

  describe "External Link" do
    let(:external_link) { FactoryBot.build(:external_link) }

    example "attach external link" do
      collection = FactoryBot.build(:collection, external_link:)
      expect(collection.external_link.title).to match(/#{external_link.title}/)
      expect(collection.external_link.link).to match(/#{external_link.link}/)
    end

    example "no external" do
      collection = FactoryBot.build(:collection)
      expect { collection.save! }.to_not raise_error
    end
  end

  describe "Space association" do
    example "Specify space in a collection" do
      space = FactoryBot.build(:space)
      collection = FactoryBot.build(:collection, space:)
      expect(collection.space).to be(space)
    end
  end

  describe "version all fields" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      # Subject not testable in rspec in this context
      # subject: ["The Text 1", "The Text 2"],
      contents: ["The Text 1", "The Text 2"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        collection = FactoryBot.create(:collection, k => v.first)
        collection.update(k => v.last)
        collection.save!
        expect(collection.versions.last.changeset[k]).to match_array(v)
      end
    end
  end
end
