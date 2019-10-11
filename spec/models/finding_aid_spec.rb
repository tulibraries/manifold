# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAid, type: :model do

  describe "version all fields", :skip do
    # [TODO] create factory with default collection
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: ["The Text 1", "The Text 2"],
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
      finding_aid = FactoryBot.create(:finding_aid, collections: [FactoryBot.create(:collection)])
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
      finding_aid = FactoryBot.build(:finding_aid, subject: [""])
      expect { finding_aid.save! }.to raise_error(/Values for either Collections or Subjects need to be selected./)
    end
  end



  it_behaves_like "categorizable"
end
