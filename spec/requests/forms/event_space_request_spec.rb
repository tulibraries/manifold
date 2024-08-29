# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charles Library Event Space Request", type: :request do

  let(:form_type) { "event-space-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      form_type:, title:, recipients:, name: "1234567890", email: "test_id@temple.edu", phone: "215-204-3836", department: "LTD", organizing_name: "Organizing Name", organizing_phone: "Organizing phone",
      organizing_email: "Organizing email", deparment: "f", financial_name: "Financial Name", financial_phone: "Financial Phone",
      financial_email: "Financial Email", foapal: "FOAPAL", event_space: "Event Space", event_title: "Event Title", attendees: "Estimated Attendees",
      date_of_event: "Date of Event", event_start: "Event Start Time", event_end: "Event End Time", setup_style: "Setup-Up Style",
      av_support: "A/V Support Needed", comments: "great", policy_check: "true", catering: "false"
    } }
  }

  it_behaves_like "email form"

end
