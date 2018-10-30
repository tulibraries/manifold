# frozen_string_literal: true

require "rails_helper"

RSpec.describe Policy, type: :model do
  after(:each) do
    DatabaseCleaner.clean
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
