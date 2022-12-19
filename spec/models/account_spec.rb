# frozen_string_literal: true

require "rails_helper"

RSpec.describe Account, type: :model do

  describe "field validators" do
    let (:account) { FactoryBot.build(:account) }
    let (:email_error) { /Email is not an email/ }
    context "Email validation" do
      example "valid email" do
        expect { account.save! }.to_not raise_error
      end
      example "invalid email" do
        account.email = "abc"
        expect { account.save! }.to raise_error(/Email is not an email/)
      end
      example "invalid email - blank " do
        account.email = ""
        expect { account.save! }.to raise_error(/Email is not an email/)
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
        "email" => account.attributes["email"]
      }
      return a
    }
    let(:invalid_access_token) {
      a = OmniAuth::AuthHash.new
      a.info = {
        "email" => "zaphod@universe.gov"
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

  describe "name field" do
    let(:account) { FactoryBot.build(:account) }
    example "exists" do
      account.save!
      expect(account.name).to match /#{Account.last["name"]}/
    end
  end

  context "admin group field" do
    before(:all) do
      @admin_group = FactoryBot.create(:admin_group)
    end

    after(:all) do
      Account.delete_all
      AdminGroup.delete_all
    end

    example "Create admin group with admin account" do
      account = FactoryBot.create(:account, admin_group: @admin_group)
      expect(account.admin_group.name).to match /^#{@admin_group.name}$/
    end
  end
end
