# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Copy Requests", type: :request do

  let(:form_type) { "copy-requests" }
  let(:the_info) { FactoryBot.create(:form_info, title: "Copy Requests", slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      form_type:, title: "Copy Requests", recipients:, name: "1234567890", email: "test_id@temple.edu", phone: "215-204-3836", temple_affiliation: "temple",
      duplication_limits: "1", copyright_acknowledgment: "1", address: "123 Main St, Philadelphia, PA 19122", collection_title: "Test Collection",
      box: "A1", folder: "B1", identifier: "12345", estimated_pages: "10", format: "tiff"
    } }
  }

  it_behaves_like "email form"

end
