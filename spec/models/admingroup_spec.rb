# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admingroup, type: :model do
  context "Admin Group has account account" do
    before(:all) do
      @member1 = FactoryBot.create(:account)
      @member2 = FactoryBot.create(:account)
    end

    after(:all) do
      Account.delete_all
      Admingroup.delete_all
    end

    example "Create admin group with admin account" do
      admingroup = FactoryBot.create(:admingroup, members: [@member1])
      expect(admingroup.members.first.email).to match /^#{@member1.email}$/
    end

    example "Create group with an admin account, and add another account" do
      admingroup = FactoryBot.create(:admingroup, members: [@member1])
      admingroup.members << @member2

      expect(admingroup.members.first.email).to match(/^#{@member1.email}$/)
      expect(admingroup.members.last.email).to match(/^#{@member2.email}$/)
    end

    example "Create group with multiple admin @members" do
      admingroup = FactoryBot.create(:admingroup, members: [@member1, @member2])
      expect(admingroup.members.first.email).to match(/^#{@member1.email}$/)
      expect(admingroup.members.last.email).to match(/^#{@member2.email}$/)
    end
  end
end
