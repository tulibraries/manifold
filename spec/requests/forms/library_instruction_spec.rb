# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Library Instruction Session", type: :request do

  let(:form_type) { "library-instruction" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "Ringo", email: "tu@temple.edu", phone: "2152041234",
      department: "LTD", course_title: "Course Title", course_code: "123",
      class_time: "Time Class Meets", instruction_mode: "Asynchronous",
      class_days: "Day(s) Class Meets", number_of_students: "Student Count",
      first_choice_date: "Requested Date",  second_choice_date: "Requested Date",
      comments: "Scope of Request"
    }
  }

  it_behaves_like "email form"

end
