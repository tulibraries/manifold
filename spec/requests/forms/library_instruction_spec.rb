# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Library Instruction Session", type: :request do

  let(:form_type) { "library-instruction" }
  let(:form_params) {
    {
      name: "Ringo", email: "tu@temple.edu", phone: "2152041234", tu_id: "Temple ID Number",
      department: "LTD", course_title: "Course Title", class_time: "Time Class Meets",
      class_days: "Day(s) Class Meets", number_of_students: "Student Count",
      requested_date: "Requested Date", campus: "Location", course_level: "Course Level",
      other: "specify other...", comments: "Scope of Request"
    }
  }

  it_behaves_like "email form"

end
