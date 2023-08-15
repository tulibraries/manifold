# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Temple Review Protocol", type: :request do

  let(:form_type) { "review-protocol" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, protocol_title: "test",
      review_update: "test",
      rationale: "test",
      explicit_statement: "test",
      information_sources: "test",
      included_keywords: "test",
      excluded_keywords: "test",
      data_plan: "test",
      independent_reviewers: "test",
      outcomes: "test",
      quantitative_analysis: "test",
      quantitative_analysis_other: "test",
      bio_statistician: "test",
      bio_statistician_other: "test",
      summary_description: "test",
      evidence_assessment: "test",
      citations: "test",
      librarian_contact: "test",
      librarian_contact_other: "test",
      authorship_permission: "test",
      authorship_permission_other: "test",
      other_reviews: "test",
      other_reviews_other: "test",
      publication_journal: "test",
    }
  }

  it_behaves_like "email form"

end
