# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAid, type: :model do

  describe "validations" do
    it { should validate_presence_of(:description) }
  end

  describe "version all fields", :skip do
    # [TODO] create factory with default collection
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      # Subject not testable in rspec in this context
      # subject: ["The Text 1", "The Text 2"],
      content_link: ["The Text 1", "The Text 2"],
      identifier: ["The Text 1", "The Text 2"],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        finding_aid = FactoryBot.create(:finding_aid, k => v.first)
        finding_aid.update(k => v.last)
        finding_aid.save!
        expect(finding_aid.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "tests for collections and subjects" do
    it "*has values in both fields*" do
      finding_aid = FactoryBot.create(:finding_aid, collections: [FactoryBot.create(:collection, :with_image)])
      expect { finding_aid.save! }.not_to raise_error
    end
    it "has subject but no collection_id" do
      finding_aid = FactoryBot.create(:finding_aid)
      expect { finding_aid.save! }.not_to raise_error
    end
    it "has collection_id but no subject" do
      finding_aid = FactoryBot.build(:finding_aid, collections: [FactoryBot.create(:collection)], subject: [""])
      expect { finding_aid.save! }.not_to raise_error(/Values for either Collections or Subjects need to be selected./)
    end
    it "has neither subject nor collection_id" do
      finding_aid = FactoryBot.build(:finding_aid, subject: [""], collections: [])
      expect { finding_aid.save! }.to raise_error(/Values for either Collections or Subjects need to be selected./)
    end
  end

  describe "Scope" do
    describe ":with_subject" do
      before do
        @f1 = FactoryBot.create(:finding_aid, subject: ["sub1"])
        @f2 = FactoryBot.create(:finding_aid, subject: ["sub1", "sub2"])
      end

      it "returns all finding aids when subejcts is empty" do
        expect(FindingAid.with_subject([])).to include(@f1, @f2)
      end

      it "returns all finding aids with one subject" do
        expect(FindingAid.with_subject(["sub1"])).to include(@f1, @f2)
      end

      it "returns only the finding aid with sub2" do
        expect(FindingAid.with_subject(["sub2"])).to include(@f2)
        expect(FindingAid.with_subject(["sub2"])).not_to include(@f1)
      end

      it "returns no finding aids with a unused subject" do
        expect(FindingAid.with_subject(["sub3"])).to eq []
      end

    end

    describe ":in_collection" do
      before do
        @coll1 = FactoryBot.create(:collection, name: "coll1")
        @coll2 = FactoryBot.create(:collection, name: "coll2")
        @f1 = FactoryBot.create(:finding_aid, collections: [@coll1])
        @f2 = FactoryBot.create(:finding_aid, collections: [@coll1, @coll2])
      end

      it "returns all finding aids when collection is empty" do
        expect(FindingAid.in_collection([])).to include(@f1, @f2)
      end

      it "returns all finding aids with common collection" do
        expect(FindingAid.in_collection([@coll1.id])).to include(@f1, @f2)
      end

      it "returns only the expected finding aid for sub2" do
        expect(FindingAid.in_collection([@coll2.id])).to include(@f2)
        expect(FindingAid.in_collection([@coll2.id])).not_to include(@f1)
      end

      it "returns no finding aids with an unknown collection" do
        expect(FindingAid.in_collection([0])).to eq []
      end
    end
  end

  it_behaves_like "categorizable"
end
