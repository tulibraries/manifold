# frozen_string_literal: true

require "rails_helper"

RSpec.describe Group, type: :model do

  context "Group Class Attributes" do
    subject { Group.new.attributes.keys }
    it { is_expected.to include("name") }
  end

  context "Group Class Rich Text Attribute" do
    subject { Group.new }
    it { is_expected.to respond_to(:description) }
  end

  describe "has many through member" do
    context "Attach person" do
      example "valid" do
        person = FactoryBot.create(:person)
        group = FactoryBot.create(:group, persons: [person])
        expect(group.persons).to include(person)
      end
    end

    context "No person" do
      let(:group) { FactoryBot.create(:group, persons: []) }
      example "valid" do
        expect { group.save! }.to_not raise_error
      end
    end
  end

  describe "has one or more file uploads" do
    context "has one file upload" do
      example "valid" do
        group = FactoryBot.create(:group, file_uploads: [FactoryBot.create(:file_upload)])
        expect { group.save! }.to_not raise_error
      end
    end
  end

  describe "has one chair_dept_heads" do
    context "Attach a chair_dept_heads" do
      example "valid" do
        chair_person = FactoryBot.create(:person, buildings: [FactoryBot.create(:building)])
        group = FactoryBot.create(:group, chair_dept_heads: [chair_person])
        expect(group.chair_dept_heads).to eq([chair_person])
      end
    end
    context "Change a chair_dept_heads" do
      example "valid" do
        chair_person_1 = FactoryBot.create(:person, buildings: [FactoryBot.create(:building)])
        chair_person_2 = FactoryBot.create(:person, last_name: "Fawlty", first_name: "Basil", buildings: [FactoryBot.create(:building)])
        group = FactoryBot.create(:group, persons: [], chair_dept_heads: [chair_person_1])
        expect(group.chair_dept_heads).to eq([chair_person_1])
        group.chair_dept_heads = [chair_person_2]
        group.save!
        expect(group.chair_dept_heads).to eq([chair_person_2])
      end
    end
  end

  describe "has many spaces through" do
    context "Attach space" do
      example "Group space is the last space created" do
        space = FactoryBot.create(:space)
        group = FactoryBot.create(:group, space:)
        expect { group.save! }.to_not raise_error
        expect(group.space).to eq(Space.last)
      end
    end
  end

  describe "field validators" do
    context "chair department head validation" do
      let(:group) { FactoryBot.build(:group, :no_chair_dept_heads) }

      it "cannot be blank" do
        expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Chair dept heads can't be blank")
      end
    end

    context "Group Type Validation" do
      let(:group) { FactoryBot.build(:group) }

      Rails.configuration.group_types.each do |group_type|
        example "valid group type #{group_type}" do
          group.group_type = group_type
          expect { group.save! }.to_not raise_error
        end
      end
      example "invalid group type" do
        group.group_type = "not a group"
        expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Group type is not a valid group type")
      end
      example "invalid group type - blank " do
        group.group_type = ""
        expect { group.save! }.to raise_error(/Group type can't be blank/)
      end
    end
  end

  context "Parent Group and child groups" do
    let(:group)  { FactoryBot.create(:group) }
    let(:pgroup) { FactoryBot.create(:group) }
    it "can have an associated parent_group" do
      group.parent_group = pgroup
      group.save
      expect(group.parent_group).to be pgroup
    end
    it "displays associated child groups" do
      another_child = FactoryBot.create(:group)
      group.parent_group = pgroup
      another_child.parent_group = pgroup
      group.save
      another_child.save
      expect(pgroup.child_groups).to match_array([group, another_child])
    end
  end

  describe "version all fields" do
    at1 = ActionText::Content.new("Hello World")
    at2 = ActionText::Content.new("Goodbye, Cruel World")
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World").to_html, ActionText::Content.new("Goodbye, Cruel World").to_html],
      external: [false, true]
    }
    fields.each do |k, v|
      #

      example "#{k} changes" do
        next if k == :description # Description not versionable
        group = FactoryBot.create(:group, k => v.first)
        group.update(k => v.last)
        group.save!
        expect(group.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "attachable"
  it_behaves_like "categorizable"
end
