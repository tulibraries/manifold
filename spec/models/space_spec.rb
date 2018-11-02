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
        space = FactoryBot.build(:space_with_building)
        space[f] = nil
        expect { space.save! }.to_not raise_error
      end
    end
  end

  describe "field validators" do

    let (:space) { FactoryBot.build(:space_with_building) }

    context "Email validation" do
      example "valid email" do
        space.email = "chas@example.edu"
        expect { space.save! }.to_not raise_error
      end
      example "invalid email" do
        space.email = "abc"
        expect { space.save! }.to raise_error(/Email is not an email/)
      end
      example "invalid email - blank " do
        space.email = ""
        expect { space.save! }.to raise_error(/#{ I18n.t('fortytude.error.invalid_email') }/)
      end
    end

    context "Phone number validation" do
      example "valid phone number" do
        space.phone_number = "2155551212"
        expect { space.save! }.to_not raise_error
      end
      example "invalid phone number" do
        space.phone_number = "215555122"
        expect { space.save! }.to raise_error(/#{I18n.t('fortytude.error.invalid_phone_format')}/)
      end
      example "invalid phone number - blank " do
        space.phone_number = ""
        expect { space.save! }.to raise_error(/#{I18n.t('fortytude.error.invalid_phone_format')}/)
      end
    end

    context "Building reference" do
      example "valid building" do
        expect { space.save! }.to_not raise_error
      end
      example "no building" do
        space = FactoryBot.build(:space)
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
        space = FactoryBot.create(:space_with_building,  policies: [Policy.create(name: "Prime Directive", description: "Don't Interfere", effective_date: Date.new(2001, 1, 1), expiration_date: Date.new(2001, 1, 2))])
        expect(space.policies.first).to eq(Policy.first)
      end
    end
  end
end
