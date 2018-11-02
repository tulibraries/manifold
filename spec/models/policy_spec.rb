# frozen_string_literal: true

require "rails_helper"

RSpec.describe Policy, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

	describe "Simple CRUD" do
		example "Just create a policy" do
      policy = Policy.new(name: "Prime Directive", description: "Don't Interfere", effective_date: Date.new(2001, 1, 1), expiration_date: Date.new(2001, 1, 2))
			expect { policy.save! }.to_not raise_error
		end
		example "Creates a policy for a building" do
			building = FactoryBot.build(:building,  policies: [Policy.create(name: "Prime Directive", description: "Don't Interfere", effective_date: Date.new(2001, 1, 1), expiration_date: Date.new(2001, 1, 2))])
			expect { building.save! }.to_not raise_error
		end
		example "Creates a policy for a building and assign it to a space too" do
			building = FactoryBot.create(:building,  policies: [Policy.create(name: "Prime Directive", description: "Don't Interfere", effective_date: Date.new(2001, 1, 1), expiration_date: Date.new(2001, 1, 2))])
			policy = building.policies.first
			space = FactoryBot.build(:space,  building: building, policies: [policy])
			expect { space.save! }.to_not raise_error
		end
	end

  describe "Required attributes" do
    example "Missing name" do
      policy = FactoryBot.build(:policy, name: "")
      expect { policy.save! }.to raise_error(/Name can't be blank/)
    end

    example "Missing description" do
      policy = FactoryBot.build(:policy, description: "")
      expect { policy.save! }.to raise_error(/Description can't be blank/)
    end

    example "Missing effective date" do
      policy = FactoryBot.build(:policy, effective_date: "")
      expect { policy.save! }.to raise_error(/Effective date can't be blank/)
    end
  end

end
