# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Recall Book Form", type: :request do

  let(:form_type) { "recall-book" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, phone: "1234567890", tu_id: "test_id", department: "test dept",
      affiliation: "Staff", author: "test author", recall_title: "test title",
      call_number: "test call number", substitute_edition: "false",
      pickup_location: "Ambler", cancellation_date: "12/01/2019"
    }
  }

  it_behaves_like "email form"

end
