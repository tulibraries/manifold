# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Storage Request Form", type: :request do

  let(:form_type) { "storage-request" }
  let(:form_params) {
    {
      name: "1234567890", tu_id: "test_id", email: "test@dept.edu",
      title: "test title", pickup_location: "Ambler"
    }
  }

  it_behaves_like "email form"

end
