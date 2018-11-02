# frozen_string_literal: true

require "rails_helper"

RSpec.describe Group, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }

  context "Group Class Attributes" do
    subject { Group.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }

  end

  describe "has many through member" do
    context "Attach person" do
      let(:group) { FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [chair_person]) }
      example "valid" do
        expect(group.persons.last.last_name).to match(/#{Person.last.last_name}/)
        expect(group.persons.last.first_name).to match(/#{Person.last.first_name}/)
      end
    end

    context "No person" do
      let(:group) { FactoryBot.create(:group, space: space, chair_dept_heads: [chair_person]) }
      example "valid" do
        expect { group.save! }.to_not raise_error
      end
    end
  end

  describe "has one chair_dept_heads" do
    context "Attach a chair_dept_heads" do
      let(:group) { FactoryBot.create(:group, persons: [], chair_dept_heads: [chair_person], space: space) }
      example "valid" do
        expect(group.chair_dept_heads.last.last_name).to match /#{chair_person.last_name}/
      end
    end
    context "Change a chair_dept_heads" do
      let(:chair_person_1) { FactoryBot.create(:person, spaces: [space]) }
      let(:chair_person_2) { FactoryBot.create(:person, last_name: "Fawlty", first_name: "Basil", spaces: [space]) }
      let(:group) { FactoryBot.create(:group, persons: [], chair_dept_heads: [chair_person_1], space: space) }
      example "valid" do
        expect(group.chair_dept_heads.last.last_name).to match /#{chair_person_1.last_name}/
        group.chair_dept_heads = [chair_person_2]
        group.save!
        expect(group.chair_dept_heads.last.last_name).to match /#{chair_person_2.last_name}/
      end
    end
  end

  describe "has many spaces through" do
    context "Attach space" do
      let(:group) { FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [chair_person]) }
      example "valid" do
        expect { group.save! }.to_not raise_error
        expect(group.space.name).to match(/#{Space.first.name}/)
      end
    end
  end


  describe "field validators" do
    let(:group) { FactoryBot.build(:group, space: space, chair_dept_heads: [chair_person]) }

    context "Space reference" do
      example "valid space ID" do
        expect { group.save! }.to_not raise_error
      end
      example "No space" do
        skip "this is now optional"
        group = FactoryBot.build(:group, chair_dept_heads: [chair_person])
        expect { group.save! }.to raise_error(/Spaces can't be blank/)
      end
    end

    context "Group Type Validation" do
      Rails.configuration.group_types.each do |group_type|
        example "valid group type #{group_type}" do
          group.group_type = group_type
          expect { group.save! }.to_not raise_error
        end
      end
      example "invalid group type" do
        group.group_type = "not a group"
        expect { group.save! }.to raise_error(/#{I18n.t('fortytude.error.invalid_group_type')}/)
      end
      example "invalid group type - blank " do
        group.group_type = ""
        expect { group.save! }.to raise_error(/Group type can't be blank/)
      end
    end
  end

  context "Policy reference" do
    let(:group) { FactoryBot.build(:group, spaces: [space], chair_dept_head: chair_person) }
    example "Add group policy" do
      group = FactoryBot.create(:space_with_building,  policies: [Policy.create(name: "Prime Directive", description: "Don't Interfere", effective_date: Date.new(2001, 1, 1), expiration_date: Date.new(2001, 1, 2))])
      expect(space.policies.first).to eq(Policy.first)
    end
  end
end
