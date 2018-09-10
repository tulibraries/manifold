require 'rails_helper'

RSpec.describe Service, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  describe "Required attributes" do
    example "Missing title" do
      service = FactoryBot.build(:service, title: "")
      expect { service.save! }.to raise_error(/Title can't be blank/)
    end

    example "Missing description" do
      service = FactoryBot.build(:service, description: "")
      expect { service.save! }.to raise_error(/Description can't be blank/)
    end

    example "Missing intended audience" do
      service = FactoryBot.build(:service, intended_audience: "")
      expect { service.save! }.to raise_error(/Intended audience can't be blank/)
    end

    example "Missing service category" do
      service = FactoryBot.build(:service, service_category: "")
      expect { service.save! }.to raise_error(/Service category can't be blank/)
    end
  end
end
