# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpage, type: :model do

  let(:external_link) { FactoryBot.create(:external_link) }

  describe "Required attributes" do
    let(:page) { FactoryBot.create(:webpage) }

    example "Missing title" do
      page = FactoryBot.build(:webpage)
      page.title = ""
      expect { page.save! }.to raise_error(/Title can't be blank/)
    end

    example "Missing description" do
      page = FactoryBot.build(:webpage, description: ActionText::Content.new(""))
      skip "required richtext field throw administrate error if blank. need to account for error before test." do
         expect { page.save! }.to raise_error(/Description can't be blank/)
       end
    end
  end

  describe "Group association" do
    example "Specify group in a page" do
      group = FactoryBot.create(:group)
      page = FactoryBot.create(:webpage, group: group)
      expect(page.group).to be(group)
    end
  end

  describe "has one or more file uploads" do
    context "has one file upload" do
      example "valid" do
        webpage = FactoryBot.create(:webpage, file_uploads: [FactoryBot.create(:file_upload)])
        expect { webpage.save! }.to_not raise_error
      end
    end
    context "has more than one file upload" do
      example "valid" do
        webpage = FactoryBot.create(:webpage, file_uploads: [FactoryBot.create(:file_upload), FactoryBot.create(:file_upload)])
        expect { webpage.save! }.to_not raise_error
      end
    end
  end

  describe "Associated Class" do
    context "External Link" do
      example "attach external link" do
        webpage = FactoryBot.create(:webpage, external_link: external_link)
        expect(webpage.external_link.title).to match(/#{external_link.title}/)
        expect(webpage.external_link.link).to match(/#{external_link.link}/)
      end
      example "no external" do
        webpage = FactoryBot.create(:webpage)
        expect { webpage.save! }.to_not raise_error
      end
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
  #       page = FactoryBot.create(:webpage, k => v.first)
  #       page.update(k => v.last)
  #       page.save!
  #       expect(page.versions.last.changeset[k]).to match_array(v)
  #     end
  #   end
  # end

  it_behaves_like "accountable"
  it_behaves_like "attachable"
  it_behaves_like "categorizable"
end
