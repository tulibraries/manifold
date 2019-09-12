# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:chair_person) { FactoryBot.build(:person, spaces: [space]) }

  describe "relation to" do
    let(:group) { FactoryBot.create(:group, chair_dept_heads: [chair_person], space: space) }
    let(:person) { FactoryBot.create(:person, groups: [group], spaces: [space]) }
    context "Group" do
      example "attach group" do
        expect(person.groups.last.name).to match(/#{group.name}/)
      end
    end
  end

  describe "Required fields" do
    example "Person must have a last name" do
      person = FactoryBot.build(:person, last_name: "", spaces: [space])
      expect { person.save! }.to raise_error(/Last name can't be blank/)
    end
    example "Person must have a first name" do
      person = FactoryBot.build(:person, first_name: "", spaces: [space])
      expect { person.save! }.to raise_error(/First name can't be blank/)
    end
  end

  describe "required relations" do
    context "Space" do
      example "attach space" do
        person = FactoryBot.create(:person, spaces: [space])
        expect { person.save! }.to_not raise_error
        expect(person.spaces.last.name).to match(/#{Space.last.name}/)
      end
      example "no space" do
        person = FactoryBot.build(:person)
        person.spaces = []
        expect { person.save! }.to raise_error(/Spaces can't be blank/)
      end
    end
  end

  describe "field validators" do
    context "Email validation" do
      example "valid email" do
        person.email_address = "chas@example.edu"
        expect { person.save! }.to_not raise_error
      end
      example "invalid email" do
        person.email_address = "abc"
        expect { person.save! }.to raise_error(/Email address is not an email/)
      end
      example "invalid email - blank " do
        person.email_address = ""
        expect { person.save! }.to raise_error(/Email address can't be blank/)
      end
    end
  end

  describe "show name" do
    example "with first and last name" do
      person = FactoryBot.create(:person, spaces: [space])
      expect(person.name).to match(/Zaphod Beeblebrox/)
    end
  end

  describe "version all fields" do
    fields = {
      first_name: ["The Text 1", "The Text 2"],
      last_name: ["The Text 1", "The Text 2"],
      phone_number: ["2155551212", "2155551234"],
      email_address: ["myaddress@temple.edu", "mynewaddress@temple.edu"],
      chat_handle: ["The Text 1", "The Text 2"],
      job_title: ["The Text 1", "The Text 2"],
      research_identifier: ["The Text 1", "The Text 2"],
      personal_site: ["The Text 1", "The Text 2"],
      springshare_id: ["The Text 1", "The Text 2"],
      libguides_account: ["The Text 1", "The Text 2"],
      specialties: ["The Text 1", "The Text 2"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        person = FactoryBot.create(:person, k => v.first)
        person.update(k => v.last)
        person.save!
        expect(person.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "specialties" do
    it "cleans out empty arrays" do
      person = FactoryBot.create(:person, spaces: [space], specialties: ["a", "", "b"])
      expect(person.specialties).to match_array(["a", "b"])
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageable"
end
