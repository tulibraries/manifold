# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminGroup, type: :model do
  context "Admin Group has account account" do
    before(:all) do
      @member1 = FactoryBot.create(:account)
      @member2 = FactoryBot.create(:account)
    end

    after(:all) do
      Account.delete_all
      AdminGroup.delete_all
    end

    example "Create admin group with admin account" do
      admin_group = FactoryBot.create(:admin_group, members: [@member1])
      expect(admin_group.members.first.email).to match(/^#{@member1.email}$/)
    end

    example "Create group with an admin account, and add another account" do
      admin_group = FactoryBot.create(:admin_group, members: [@member1])
      admin_group.members << @member2

      expect(admin_group.members.first.email).to match(/^#{@member1.email}$/)
      expect(admin_group.members.last.email).to match(/^#{@member2.email}$/)
    end

    example "Create group with multiple admin @members" do
      admin_group = FactoryBot.create(:admin_group, members: [@member1, @member2])
      expect(admin_group.members.first.email).to match(/^#{@member1.email}$/)
      expect(admin_group.members.last.email).to match(/^#{@member2.email}$/)
    end
  end

  describe "Managing Entities" do
    let(:admin_group) { FactoryBot.create(:admin_group) }
    let(:admin_group2) { FactoryBot.create(:admin_group) }
    let(:saved_admin_group) { AdminGroup.find(admin_group.id) }
    context "a single valid entity" do
      it "can be persisted" do
        admin_group.managed_entities << "Blog"
        admin_group.save!
        expect(saved_admin_group.managed_entities).to eql(["Blog"])
      end
    end
    context "a single invalid entity" do
      it "raises a validation error" do
        admin_group.managed_entities << "NonExistentEntityType"
        expect { admin_group.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context "multiple valid entities" do
      it "can be persisted" do
        admin_group.managed_entities << "Blog"
        admin_group.managed_entities << "Person"
        admin_group.save!
        expect(saved_admin_group.managed_entities).to eql(["Blog", "Person"])
      end
    end
    context "FormSubmission managed entity" do
      it "can be assigned to an admin group" do
        admin_group.managed_entities << "FormSubmission"
        admin_group.save!
        expect(saved_admin_group.managed_entities).to include("FormSubmission")
      end
    end

    context "a mix of valid and invalid entities" do
      it "raises a validation error" do
        admin_group.managed_entities << ["NonExistentEntityType", "Blog"]
        expect { admin_group.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    describe "entity uniqueness management validation" do
      it "prevents an entity type form being managed by multiple admin groups" do
        admin_group.managed_entities << "Person"
        admin_group.save
        admin_group2.managed_entities << "Person"
        expect { admin_group2.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
