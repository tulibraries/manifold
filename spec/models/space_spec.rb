# frozen_string_literal: true

require "rails_helper"

RSpec.describe Space, type: :model do

  context "Required Fields" do
    required_fields = [
      "name",
      "description",
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
        space = FactoryBot.build(:space)
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
        space = FactoryBot.build(:space)
        space[f] = nil
        expect { space.save! }.to_not raise_error
      end
    end
  end

  describe "field validators" do

    let (:space) { FactoryBot.build(:space) }

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
        space = FactoryBot.build(:space_with_parent)
        expect { space.save! }.to_not raise_error
      end
    end

    context "Policy reference" do
      example "Add space policy" do
        policy = FactoryBot.create(:policy)
        space = FactoryBot.create(:space)
        space.policies << policy
        expect(space.policies).to include(policy)
      end
    end
  end
end
