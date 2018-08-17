require 'rails_helper'

RSpec.describe Account, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  describe "field validators" do
    let (:account) { FactoryBot.build(:account) }
    let (:email_error) { /Email is not an email/ }
    context "Email validation" do
      example "valid email", focus: true do
        expect { account.save! }.to_not raise_error
      end
      example "invalid email" do
        account.email = "abc"
        expect { account.save! }.to raise_error(email_error)
      end
      example "invalid email - blank " do
        account.email = ""
        expect { account.save! }.to raise_error(email_error)
      end
      example "non TU access ID" do
        account.email = "stella@temple.edu"
        expect { account.save! }.to_not raise_error
      end
      example "no quite a TU access ID" do
        account.email = "tua1234@temple.edu"
        expect { account.save! }.to_not raise_error
      end
      example "no quite a TU access ID" do
        account.email = "tua123456@temple.edu"
        expect { account.save! }.to_not raise_error
      end
    end
  end

  context "from_omniauth" do
    before(:each) do
      OmniAuth.config.test_mode = true
    end
    let(:account) { FactoryBot.create(:account) }
    let(:valid_access_token) {
      a = OmniAuth::AuthHash.new
      a.info = {
        "email"=>account.attributes["email"]
      }
      return a
    }
    let(:invalid_access_token) {
      a = OmniAuth::AuthHash.new
      a.info = {
        "email"=>"zaphod@universe.gov"
      }
      return a
    }

    example "Valid account" do
      a = Account.from_omniauth(valid_access_token)
      expect(a).to_not be_nil
      expect(a.email).to match /#{account["email"]}/
    end

    example "Invalid account" do
      a = Account.from_omniauth(invalid_access_token)
      expect(a).to be_nil
    end
  end
end
