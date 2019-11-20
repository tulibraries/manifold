# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "accountable" do
  let(:model) { described_class } # the class that includes the concern
  let(:account) { FactoryBot.create(:account) }
  let(:account2) { FactoryBot.create(:account) }
  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:single_account) {
    factory_model.individual_owners << account
    factory_model
  }
  let(:multiple_accounts) {
    factory_model.individual_owners << account
    factory_model.individual_owners << account2
    factory_model
  }

  it "has an accounts method" do
    expect(factory_model).to respond_to(:accounts)
  end

  it "can have one account added to it" do
    expect { single_account }.not_to raise_error
  end

  it "can have multiple accounts added to it" do
    expect { multiple_accounts }.not_to raise_error
  end


  context "when it has no accounts" do
    it "the accounts method returns an empty object" do
      expect(factory_model.individual_owners).to be_empty
    end
  end

  context "when it has one accounts" do
    it "the accounts method returns an array with the expected account" do
      expect(single_account.individual_owners).to include(account)
    end
  end

  context "when it has multiple accounts" do
    it "the accounts method returns an array with the expected accounts" do
      expect(multiple_accounts.individual_owners).to include(account, account2)
    end

    it "throws an error if duplicate accounts are added to an item" do
      expect {
        factory_model.individual_owners << account
        factory_model.individual_owners << account
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "when a account is deleted" do
    it "removes that account for an item's accounts" do
      factory_model.individual_owners << account
      account.destroy
      factory_model.reload
      expect(factory_model.individual_owners).to match_array([])
    end

  end


end
