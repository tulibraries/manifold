# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SCRC Instruction Request", type: :request do

  let(:form_type) { "scrc-instruction" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients: "[\"recipient@temple.edu\"]", name: "yes", email: "no@maybe.com", phone: "none", course_title: "Course Title",
      course_number: "Course Code and Number", number_of_students: "Number of Students",
      minors: "false", comments: "Goals for This Session/What Do You Want Us to Cover?",
      preferred_date: "12/01/2000", preferred_time: "15:00"
    } }
  }

  it_behaves_like "email form"

end
