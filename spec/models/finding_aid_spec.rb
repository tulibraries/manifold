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
end
