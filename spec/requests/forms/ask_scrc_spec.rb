# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ask SCRC Form", type: :request do

  let(:form_type) { "ask-scrc" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "Joe", email: "test@temple.edu", phone: "1234567890", affiliation: "Staff", comments: "test comment"
    }
  }

  it_behaves_like "email form"

end
