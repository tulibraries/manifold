require 'rails_helper'

RSpec.describe Account, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'Account Class Attributes' do
    subject { Account.new.attributes.keys }

    it { is_expected.to include("email") }
    it { is_expected.to include("encrypted_password") }
    it { is_expected.to include("reset_password_token") }
    it { is_expected.to include("reset_password_sent_at") }
    it { is_expected.to include("remember_created_at") }
    it { is_expected.to include("sign_in_count") }
    it { is_expected.to include("current_sign_in_at") }
    it { is_expected.to include("last_sign_in_at") }
    it { is_expected.to include("current_sign_in_ip") }
    it { is_expected.to include("last_sign_in_ip") }
    it { is_expected.to include("created_at") }
    it { is_expected.to include("updated_at") }
  end

  describe "field validators" do
    let (:account) { FactoryBot.build(:account) }
    let (:email_error) { /Email is not an acceptable email address/ }
    context "Email validation" do
      example "valid email", focus: true do
        expect { account.save! }.to_not raise_error
      end
      example "unpermitted email" do
        account.email = "abc.example.edu"
        expect { account.save! }.to raise_error(email_error)
      end
      example "invalid email" do
        account.email = "abc"
        expect { account.save! }.to raise_error(email_error)
      end
      example "invalid email - blank " do
        account.email = ""
        expect { account.save! }.to raise_error(email_error)
      end
    end
  end
end
