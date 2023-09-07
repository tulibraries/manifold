# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Group Visit Request", type: :request do

  let(:form_type) { "group-visit" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "yes", email: "no@maybe.com", phone: "none", reason_for_request: "test_id", requested_date: "Graduate",
      attendees: "7", minors: "true", school_visit: "Umbrella Academy", referrer: "Mr Moto", comments: "none"
    }
  }

  it_behaves_like "email form"

end
