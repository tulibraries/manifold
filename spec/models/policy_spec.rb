# frozen_string_literal: true

require "rails_helper"

RSpec.describe Policy, type: :model do
  describe "Policy Creation" do
    example "Just create a policy" do
      policy = FactoryBot.create(:policy)
      expect { policy.save! }.to_not raise_error
    end
  end

  describe "Policy association" do
    example "Creates a policy for a building" do
      policy = FactoryBot.create(:policy)
      building = FactoryBot.create(:building)
      building.policies << policy
      expect(building.policies).to include(policy)
    end

    example "Creates a policy for a building and assign it to a space too" do
      policy = FactoryBot.create(:policy)
      building = FactoryBot.create(:building)
      building.policies = [policy]
      space = FactoryBot.create(:space, building:)
      space.policies = [policy]
      expect(space.policies).to include(policy)
    end
  end

  describe "Required attributes" do
    example "Missing name" do
      policy = FactoryBot.build(:policy, name: "")
      expect { policy.save! }.to raise_error(/Name can't be blank/)
    end
  end

  describe "version all fields" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      effective_date: [Date.parse("2018/9/24"), Date.parse("2018/10/24")],
      expiration_date: [Date.parse("2018/9/24"), Date.parse("2018/10/24")],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        policy = FactoryBot.create(:policy, k => v.first)
        policy.update(k => v.last)
        policy.save!
        expect(policy.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "accountable"
  it_behaves_like "categorizable"
end
