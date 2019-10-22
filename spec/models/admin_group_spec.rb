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
      expect(admin_group.members.first.email).to match /^#{@member1.email}$/
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
end
