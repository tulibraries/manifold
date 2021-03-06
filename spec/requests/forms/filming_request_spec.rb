# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Guidelines for Requesting Permission to Use the Libraries for Filming", type: :request do

  let(:form_type) { "filming-request" }
  let(:form_params) {
    {
      requestor: "1234567890", email: "test_id@temple.edu", affiliation: "junior", location_of_filming: "test dept",
      date_of_filming: "Staff", time_of_filming: "test author", duration_of_filming: "five days",
      description: "An alien orphan is sent from his dying planet to Earth",
      temple_course_project: "t", additional_crew_name: "7", additional_email: "test_je@temple.edu"
    }
  }

  it_behaves_like "email form"

end
