# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Guidelines for Requesting Permission to Use the Libraries for Filming", type: :request do

  let(:form_type) { "filming-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients:, requestor: "1234567890", email: "test_id@temple.edu", affiliation: "junior", location_of_filming: "test dept",
      date_of_filming: "Staff", time_of_filming: "test author", duration_of_filming: "five days",
      description: "An alien orphan is sent from his dying planet to Earth", total_number_of_production_members: "7",
      mobile_number: "2152046667", mobile_telephone_number_of_the_key_crew_member: "2152046667",
      temple_course_project: "t", additional_crew_name: "7", additional_email: "test_je@temple.edu"
    } }
  }

  it_behaves_like "email form"

end
