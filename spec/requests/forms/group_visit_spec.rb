# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Group Visit Request", type: :request do

  let(:form_type) { "group-visit" }
  let(:form_params) {
    {
      name: "yes", email: "no@maybe.com", phone: "none", description: "test_id", requested_date: "Graduate",
      attendees: "7", minors: "true", school_visit: "Umbrella Academy", referrer: "Mr Moto", comments: "none"
    }
  }

  it_behaves_like "email form"

end
