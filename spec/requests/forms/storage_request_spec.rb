# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Recall item from Charles Library temporary storage", type: :request do

  let(:form_type) { "storage-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "1234567890", tu_id: "test_id", email: "test@dept.edu",
      book_title: "test title", call_number: "test-123 p.1", pickup_location: "Ambler"
    }
  }

  it_behaves_like "email form"

end
