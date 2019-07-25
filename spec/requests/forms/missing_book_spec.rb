# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Missing Book Form", type: :request do

  let(:form_type) { "missing-book" }
  let(:form_params) {
    {
      phone: "1234567890", tu_id: "test_id", department: "test dept",
      affiliation: "Staff", author: "test author", title: "test title",
      call_number: "test call number"
    }
  }

  it_behaves_like "email form"

end
