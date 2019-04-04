# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page, type: :model do
  describe "Required attributes" do
    let(:page) { FactoryBot.create(:page) }

    example "Missing title" do
      page = FactoryBot.build(:page)
      page.title = ""
      expect { page.save! }.to raise_error(/Title can't be blank/)
    end

    example "Missing description" do
      page = FactoryBot.build(:page)
      page.description = ""
      expect { page.save! }.to raise_error(/Description can't be blank/)
    end
  end

  describe "Group association" do
    example "Specify group in a page" do
      group = FactoryBot.create(:group)
      page = FactoryBot.create(:page, group: group)
      expect(page.group).to be(group)
    end
  end

  # Versioning needs to be added to the model before we can test for it

  # describe "version all fields" do
  #   fields = {
  #     name: ["The Text 1", "The Text 2"],
  #     description: ["The Text 1", "The Text 2"],
  #   }

  #   fields.each do |k, v|
  #     example "#{k} changes" do
  #       page = FactoryBot.create(:page, k => v.first)
  #       page.update(k => v.last)
  #       page.save!
  #       expect(page.versions.last.changeset[k]).to match_array(v)
  #     end
  #   end
  # end
end
