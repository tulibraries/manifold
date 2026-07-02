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
  end

  describe "Group association" do
    example "Specify group in a page" do
      group = FactoryBot.create(:group)
      page = FactoryBot.create(:webpage, group:)
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
          @with_uploads.fileabilities.second.update(featured: true)
        end
        it "removes item from items array" do
          expect(@with_uploads.items.map(&:file_upload_id)).to_not eql [@file2.id]
          expect(@with_uploads.items.map(&:file_upload_id)).to eql [@file1.id]
        end

        it "returns the featured file upload" do
          expect(@with_uploads.featured_item.file_upload_id).to eq(@file2.id)
        end
      end
    end
  end

  describe "#featured_item" do
    context "when an external_link_webpage is featured" do
      before do
        @featured_link = FactoryBot.create(:external_link, title: "Featured")
        @other_link = FactoryBot.create(:external_link, title: "Other")
        @webpage = FactoryBot.create(:webpage, external_links: [@featured_link, @other_link])
        @webpage.external_link_webpages.find_by(external_link: @featured_link).update!(featured: true)
      end

      it "returns the featured external_link_webpage" do
        expect(@webpage.featured_item.external_link).to eq(@featured_link)
      end
    end

    context "when nothing is featured" do
      it "returns nil" do
        webpage = FactoryBot.create(:webpage, :with_file)
        expect(webpage.featured_item).to be_nil
      end
    end
  end

  describe "#file_items" do
    it "excludes the featured fileability" do
      file1 = FactoryBot.create(:file_upload, name: "A")
      file2 = FactoryBot.create(:file_upload, name: "B")
      webpage = FactoryBot.create(:webpage, file_uploads: [file1, file2])
      webpage.fileabilities.find_by(file_upload: file2).update!(featured: true)

      expect(webpage.file_items.map(&:file_upload)).to contain_exactly(file1)
    end

    it "includes all fileabilities when none are featured" do
      file1 = FactoryBot.create(:file_upload, name: "A")
      file2 = FactoryBot.create(:file_upload, name: "B")
      webpage = FactoryBot.create(:webpage, file_uploads: [file1, file2])

      expect(webpage.file_items.map(&:file_upload)).to contain_exactly(file1, file2)
    end
  end

  describe "#online_links" do
    it "excludes the featured external_link_webpage" do
      featured_link = FactoryBot.create(:external_link, title: "Featured")
      other_link = FactoryBot.create(:external_link, title: "Other")
      webpage = FactoryBot.create(:webpage, external_links: [featured_link, other_link])
      webpage.external_link_webpages.find_by(external_link: featured_link).update!(featured: true)

      expect(webpage.online_links.map(&:external_link)).to contain_exactly(other_link)
    end

    it "includes all external link webpages when none are featured" do
      link1 = FactoryBot.create(:external_link, title: "A")
      link2 = FactoryBot.create(:external_link, title: "B")
      webpage = FactoryBot.create(:webpage, external_links: [link1, link2])

      expect(webpage.online_links.map(&:external_link)).to contain_exactly(link1, link2)
    end
  end

  describe "#items" do
    it "combines file_items and online_links" do
      file = FactoryBot.create(:file_upload, name: "Report")
      link = FactoryBot.create(:external_link, title: "Link")
      webpage = FactoryBot.create(:webpage, file_uploads: [file], external_links: [link])

      expect(webpage.items.length).to eq(2)
      expect(webpage.items).to include(
        an_object_satisfying { |i| i.is_a?(Fileability) },
        an_object_satisfying { |i| i.is_a?(ExternalLinkWebpage) }
      )
    end

    it "excludes featured items from both types" do
      file1 = FactoryBot.create(:file_upload, name: "Featured File")
      file2 = FactoryBot.create(:file_upload, name: "Other File")
      link1 = FactoryBot.create(:external_link, title: "Featured Link")
      link2 = FactoryBot.create(:external_link, title: "Other Link")
      webpage = FactoryBot.create(:webpage, file_uploads: [file1, file2], external_links: [link1, link2])
      webpage.fileabilities.find_by(file_upload: file1).update!(featured: true)

      expect(webpage.items.map { |i| i.try(:file_upload) || i.try(:external_link) })
        .to contain_exactly(file2, link1, link2)
    end

    it "orders by weight regardless of item type" do
      file = FactoryBot.create(:file_upload, name: "File")
      link = FactoryBot.create(:external_link, title: "Link")
      webpage = FactoryBot.create(:webpage, file_uploads: [file], external_links: [link])
      webpage.fileabilities.first.update!(weight: 1)
      webpage.external_link_webpages.first.update!(weight: 2)

      expect(webpage.items.first).to be_a(Fileability)
      expect(webpage.items.last).to be_a(ExternalLinkWebpage)

      webpage.fileabilities.first.update!(weight: 2)
      webpage.external_link_webpages.first.update!(weight: 1)

      expect(webpage.items.first).to be_a(ExternalLinkWebpage)
      expect(webpage.items.last).to be_a(Fileability)
    end
  end

  describe "Associated Class" do
    context "External Link" do
      example "attach external link" do
        webpage = FactoryBot.create(:webpage, external_link:)
        expect(webpage.external_link.title).to match(/#{external_link.title}/)
        expect(webpage.external_link.link).to match(/#{external_link.link}/)
      end
      example "no external" do
        webpage = FactoryBot.create(:webpage)
        expect { webpage.save! }.to_not raise_error
      end
    end
  end

  describe "#label" do
    let(:webpage) { FactoryBot.build(:webpage) }

    it "has a label with the title" do
      expect(webpage.label).to eq(webpage.title)
    end
  end

  describe "#schema_dot_org_type" do
    let(:webpage) { FactoryBot.build(:webpage) }

    it "has a type of webpage" do
      expect(webpage.schema_dot_org_type).to eq("WebPage")
    end
  end

  describe "#additional_schema_dot_org_attributes" do
    let(:webpage) { FactoryBot.build(:webpage) }

    it "includes the webpage title" do
      expect(webpage.additional_schema_dot_org_attributes).to include(name: webpage.title)
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
