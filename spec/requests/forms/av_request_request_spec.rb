# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AV Requests", type: :request do

  let(:form_type) { "av-requests" }
  let(:the_info) { FactoryBot.create(:form_info, title: "AV Requests", slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      form_type:, title: "AV Requests", recipients:, name: "1234567890", email: "test_id@temple.edu", phone: "215-204-3836", temple_afilliation: "temple",
      outside_vendor_fees: "1", duplication_limits: "1", copyright_acknowledgment: "1", address: "123 Main St, Philadelphia, PA 19122",
      collection_title: "Test Collection", identifier: "12345", notes: "Test notes", format: "Digital"
    } }
  }

  it_behaves_like "email form"

end
