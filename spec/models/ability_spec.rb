# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ability, type: :model do
  describe "regular ability" do
    let(:account) { FactoryBot.create(:account) }
    let(:ability) { Ability.new(account) }
    example "can read everything" do
      expect(ability.can?(:read, :all)).to be(true)
    end
    example "can manage base entities (not AdminGroup-managed)" do
      expect(ability.can?(:manage, Space)).to be(true)
      expect(ability.can?(:manage, Group)).to be(true)
      expect(ability.can?(:manage, Service)).to be(true)
      expect(ability.can?(:manage, Collection)).to be(true)
      expect(ability.can?(:manage, Category)).to be(false)
    end

    example "cannot manage AdminGroup-managed entities (requires AdminGroup membership)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:manage, Blog)).to be(false)
    end
    example "cannot manage admin-only entities" do
      expect(ability.can?(:manage, AdminGroup)).to be(false)
      expect(ability.can?(:manage, Account)).to be(false)
      expect(ability.can?(:update, Alert)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end
  end

  describe "alert ability" do
    let(:account) { FactoryBot.create(:account, alertability: true) }
    let(:ability) { Ability.new(account) }
    example "ability" do
      expect(ability.can?(:update, Alert)).to be(true)
    end
    example "inability" do
      expect(ability.can?(:manage, :all)).to be(false)
    end
  end

  describe "admin ability" do
    let(:account) { FactoryBot.create(:account, admin: true) }
    let(:ability) { Ability.new(account) }
    example "ability" do
      expect(ability.can?(:manage, :all)).to be((true))
    end
  end

  describe "admin group ability - Form Submission only (RESTRICTIVE)" do
    let(:admin_group) { FactoryBot.create(:admin_group, managed_entities: ["FormSubmission"]) }
    let(:account) { FactoryBot.create(:account, admin: false, admin_group: admin_group) }
    let(:ability) { Ability.new(account) }

    example "can manage FormSubmission (their only allowed entity)" do
      expect(ability.can?(:manage, FormSubmission)).to be(true)
    end

    example "cannot manage base entities (restricted - student workers)" do
      expect(ability.can?(:manage, Building)).to be(false)
      expect(ability.can?(:manage, Person)).to be(false)
      expect(ability.can?(:manage, Space)).to be(false)
      expect(ability.can?(:manage, Group)).to be(false)
    end

    example "cannot manage admin-only entities" do
      expect(ability.can?(:manage, AdminGroup)).to be(false)
      expect(ability.can?(:manage, Account)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end

    example "can only manage FormSubmissions (completely locked down)" do
      expect(ability.can?(:manage, FormSubmission)).to be(true)
      expect(ability.can?(:manage, Building)).to be(false)
      expect(ability.can?(:manage, Person)).to be(false)
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:read, Building)).to be(false)
      expect(ability.can?(:read, Person)).to be(false)
      expect(ability.can?(:read, Event)).to be(false)
      expect(ability.can?(:read, :all)).to be(false)
    end
  end

  describe "admin group ability - Mixed entities (ADDITIVE)" do
    let(:admin_group) { FactoryBot.create(:admin_group, managed_entities: ["Event", "Blog"]) }
    let(:account) { FactoryBot.create(:account, admin: false, admin_group: admin_group) }
    let(:ability) { Ability.new(account) }

    example "can manage assigned entities from admin group" do
      expect(ability.can?(:manage, Event)).to be(true)
      expect(ability.can?(:manage, Blog)).to be(true)
    end

    example "can STILL manage base entities (additive permissions)" do
      expect(ability.can?(:manage, Space)).to be(true)
      expect(ability.can?(:manage, Group)).to be(true)
      expect(ability.can?(:manage, Service)).to be(true)
    end

    example "cannot manage other AdminGroup-managed entities (only gets their assigned entities)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
      expect(ability.can?(:manage, Exhibition)).to be(false)
      expect(ability.can?(:manage, Highlight)).to be(false)
    end
  end

  describe "admin group ability - No admin group (regular user)" do
    let(:account) { FactoryBot.create(:account, admin: false, admin_group: nil) }
    let(:ability) { Ability.new(account) }

    example "can manage base entities (not AdminGroup-managed)" do
      expect(ability.can?(:manage, Space)).to be(true)
      expect(ability.can?(:manage, Group)).to be(true)
      expect(ability.can?(:manage, Service)).to be(true)
    end

    example "cannot manage AdminGroup-managed entities (requires AdminGroup membership)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:manage, Blog)).to be(false)
    end

    example "cannot manage entities that require admin groups" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:manage, Blog)).to be(false)
    end

    example "cannot manage admin-only entities" do
      expect(ability.can?(:manage, AdminGroup)).to be(false)
      expect(ability.can?(:manage, Account)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end

    example "can read everything" do
      expect(ability.can?(:read, FormSubmission)).to be(true)
      expect(ability.can?(:read, Building)).to be(true)
      expect(ability.can?(:read, Person)).to be(true)
      expect(ability.can?(:read, :all)).to be(true)
    end
  end

  describe "regular user cannot access AdminGroup-managed entities" do
    # Create an admin group that manages certain entities
    let!(:form_admin_group) { FactoryBot.create(:admin_group, managed_entities: ["FormSubmission"]) }
    let!(:media_admin_group) { FactoryBot.create(:admin_group, managed_entities: ["Event", "Blog"]) }

    # Regular user with no admin group
    let(:regular_user) { FactoryBot.create(:account, admin: false, admin_group: nil) }
    let(:ability) { Ability.new(regular_user) }

    example "cannot manage FormSubmission (managed by FormSubmission admin group)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
    end

    example "cannot manage Event (managed by Media admin group)" do
      expect(ability.can?(:manage, Event)).to be(false)
    end

    example "cannot manage Blog (managed by Media admin group)" do
      expect(ability.can?(:manage, Blog)).to be(false)
    end

    example "can manage base entities (all users can manage these)" do
      expect(ability.can?(:manage, Space)).to be(true)
      expect(ability.can?(:manage, Group)).to be(true)
      expect(ability.can?(:manage, Service)).to be(true)
    end

    example "cannot manage AdminGroup-managed entities (requires AdminGroup membership)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:manage, Blog)).to be(false)
    end

    example "can read AdminGroup-managed entities (read access is open)" do
      expect(ability.can?(:read, FormSubmission)).to be(true)
      expect(ability.can?(:read, Event)).to be(true)
      expect(ability.can?(:read, Blog)).to be(true)
    end
  end

  describe "Special Collections admin group - Special case for FormSubmissions" do
    let(:admin_group) { FactoryBot.create(:admin_group, name: "Special Collections", managed_entities: ["Exhibition", "Highlight"]) }
    let(:account) { FactoryBot.create(:account, admin: false, admin_group: admin_group) }
    let(:ability) { Ability.new(account) }

    example "can manage their assigned entities" do
      expect(ability.can?(:manage, Exhibition)).to be(true)
      expect(ability.can?(:manage, Highlight)).to be(true)
    end

    example "can manage FormSubmissions (special case)" do
      expect(ability.can?(:manage, FormSubmission)).to be(true)
    end

    example "can STILL manage base entities (additive permissions)" do
      expect(ability.can?(:manage, Space)).to be(true)
      expect(ability.can?(:manage, Group)).to be(true)
      expect(ability.can?(:manage, Service)).to be(true)
    end

    example "cannot manage other AdminGroup-managed entities (except FormSubmissions - special case)" do
      expect(ability.can?(:manage, Event)).to be(false)
      expect(ability.can?(:manage, Blog)).to be(false)
      expect(ability.can?(:manage, ExternalLink)).to be(false)
    end

    example "cannot manage admin-only entities" do
      expect(ability.can?(:manage, AdminGroup)).to be(false)
      expect(ability.can?(:manage, Account)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end

    example "can read everything" do
      expect(ability.can?(:read, FormSubmission)).to be(true)
      expect(ability.can?(:read, Exhibition)).to be(true)
      expect(ability.can?(:read, :all)).to be(true)
    end
  end

  describe "Other admin groups cannot access FormSubmissions" do
    let(:admin_group) { FactoryBot.create(:admin_group, name: "Library Communication", managed_entities: ["Event", "Blog"]) }
    let(:account) { FactoryBot.create(:account, admin: false, admin_group: admin_group) }
    let(:ability) { Ability.new(account) }

    example "can manage their assigned entities" do
      expect(ability.can?(:manage, Event)).to be(true)
      expect(ability.can?(:manage, Blog)).to be(true)
    end

    example "cannot manage FormSubmissions (not Special Collections or Form Submissions group)" do
      expect(ability.can?(:manage, FormSubmission)).to be(false)
    end

    example "can read FormSubmissions" do
      expect(ability.can?(:read, FormSubmission)).to be(true)
    end
  end

  describe "no account (anonymous user)" do
    let(:ability) { Ability.new(nil) }

    example "cannot read anything" do
      expect(ability.can?(:read, Building)).to be(false)
      expect(ability.can?(:read, Person)).to be(false)
      expect(ability.can?(:read, :all)).to be(false)
    end

    example "cannot manage anything" do
      expect(ability.can?(:manage, Building)).to be(false)
      expect(ability.can?(:manage, :all)).to be(false)
    end
  end
end
