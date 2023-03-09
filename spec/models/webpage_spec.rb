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

    describe "#items" do

      context "no uploads attached" do
        before(:each) do
          file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage, file_uploads: [file1, file2])
          @without_uploads = FactoryBot.create(:webpage)
        end
        it "should return an array" do
          expect(@without_uploads.items).to be_a_kind_of(Array)
        end

        it "should be an empty array" do
          expect(@without_uploads.items).to eql []
        end
      end

      context "uploads attached" do
        before(:each) do
          @file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          @file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage, file_uploads: [@file1, @file2])
          @without_uploads = FactoryBot.create(:webpage)
        end
        it "should return an array" do
          expect(@with_uploads.items).to be_a_kind_of(Array)
        end

        it "should include expected items" do
          expect(@with_uploads.file_uploads).to include(@file1, @file2)
        end
      end

      context "when items in a category are weighted" do
        before(:each) do
          @file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          @file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage, file_uploads: [@file1])
          @with_uploads.fileabilities.first.update("weight" => 3)
          @with_uploads.file_uploads << @file2
          @with_uploads.fileabilities.second.update("weight" => 2)
        end

        it "returns items in the expected order" do
          expect(@with_uploads.items.map(&:file_upload_id)).to eql [@file2.id, @file1.id]
        end
      end

      context "when some items in a category are weighted and some are not" do
        before do
          @file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          @file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage, file_uploads: [@file1])
          @with_uploads.file_uploads << @file2
          @with_uploads.fileabilities.second.update("weight" => 2)
        end

        it "weighted items sort first, in expected order, followed by unweighted items" do
          expect(@with_uploads.items.map(&:file_upload_id)).to eql [@file2.id, @file1.id]
        end
      end

      context "when no items are weighted" do
        before do
          @file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          @file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage)
          @with_uploads.file_uploads << @file2
          @with_uploads.file_uploads << @file1
        end
        it "sorts them alphabetically by label" do
          expect(@with_uploads.items.map(&:file_upload_id)).to eql [@file1.id, @file2.id]
        end
      end

      context "when there is a featured item" do
        before do
          @file1 = FactoryBot.create(:file_upload, name: "A Good Day")
          @file2 = FactoryBot.create(:file_upload, name: "Sunshine and Blue Skies")
          @with_uploads = FactoryBot.create(:webpage, file_uploads: [@file1])
          @with_uploads.fileabilities.first.update("weight" => 2)
          @with_uploads.file_uploads << @file2
          @with_uploads.fileabilities.second.update("weight" => 1)
        end
        it "puts item into featured variable" do
          expect(@with_uploads.featured_item.file_upload_id).to eql @file2.id
        end
        it "removes item from items array" do
          expect(@with_uploads.items.map(&:file_upload_id)).to_not eql [@file2.id]
          expect(@with_uploads.items.map(&:file_upload_id)).to eql [@file1.id]
        end
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

  # it_behaves_like "accountable"
  # it_behaves_like "attachable"
  it_behaves_like "categorizable"
end
