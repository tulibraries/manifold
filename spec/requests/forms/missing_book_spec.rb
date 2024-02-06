# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Missing Book Form", type: :request do

  let(:form_type) { "missing-book" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients:, phone: "1234567890", tu_id: "test_id", department: "test dept",
      affiliation: "Staff", author: "test author", missing_title: "test title",
      call_number: "test call number"
    } }
  }

  it_behaves_like "email form"

end
