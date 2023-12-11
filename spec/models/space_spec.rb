# frozen_string_literal: true

require "rails_helper"

RSpec.describe Space, type: :model do

  let (:building) { FactoryBot.create(:building) }

  context "Required Fields" do
    # "required richtext field (description) throws administrate error if blank. need to account for error before test."
    # required_fields = [
    #   "name",
    #   "description",
    #   "building_id",
    # ]
    required_fields = [
      "name",
      "building_id",
    ]
    required_fields.each do |f|
      example "missing #{f} fields" do
        space = FactoryBot.build(:space)
        space[f] = ""
        expect { space.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end

    required_references = [
      "building_id",
    ]
    required_references.each do |f|
      example "missing #{f}" do
        space = FactoryBot.build(:space, building:)
        space[f] = nil
        expect { space.save! }.to raise_error(/#{f.humanize(capitalize: true)} must exist/)
      end
    end
  end

  context "Optional Fields" do
    optional_references = [
      "ancestry",
    ]
    optional_references.each do |f|
      example "missing #{f}" do
        space = FactoryBot.build(:space, building:)
        space[f] = nil
        expect { space.save! }.to_not raise_error
      end
    end
  end

  describe "field validators" do

    let (:space) { FactoryBot.build(:space, building:) }

    context "Building reference" do
      example "valid building" do
        expect { space.save! }.to_not raise_error
      end
      example "no building" do
        space = FactoryBot.build(:space, building: nil)
        expect { space.save! }.to raise_error(/Building can't be blank/)
      end
    end

    context "Optional parent space reference" do
      example "no space ID" do
        space.parent = nil
        expect { space.save! }.to_not raise_error
      end
      example "valid space ID" do
        space = FactoryBot.build(:space_with_parent, building:)
        expect { space.save! }.to_not raise_error
      end
    end

    context "External Link" do
      let(:external_link) { FactoryBot.create(:external_link) }
      example "attach external link" do
        space = FactoryBot.create(:space, external_link:)
        expect(space.external_link.title).to match(/#{external_link.title}/)
        expect(space.external_link.link).to match(/#{external_link.link}/)
      end
      example "no external" do
        space = FactoryBot.create(:space)
        expect { space.save! }.to_not raise_error
      end
    end
  end

  describe "version field changes" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      hours: ["The Text 1", "The Text 2"],
      accessibility: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      phone_number: ["2155551212", "2155551234"],
      email: ["first@example.com", "second@email.com"],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        skip("accessibility not versionable") if k == :accessibility
        space = FactoryBot.create(:space, k => v.first)
        space.update(k => v.last)
        space.save!
        expect(space.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "accountable"
  it_behaves_like "categorizable"
  it_behaves_like "imageable"
end
