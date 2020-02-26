# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ask SCRC Form", type: :request do

  let(:form_type) { "ask-scrc" }
  let(:form_params) {
    {
      name: "Joe", email: "test@temple.edu", phone: "1234567890", affiliation: "Staff", comments: "test comment"
    }
  }

  it_behaves_like "email form"

end
