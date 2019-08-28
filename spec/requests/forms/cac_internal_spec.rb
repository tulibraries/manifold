# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cultural Analytics Certificate Internal Application", type: :request do

  let(:form_type) { "cac-internal" }
  let(:form_params) {
    {
      name: "Ringo", email: "tu@temple.edu", phone: "2152041234", tu_id: "Temple ID Number",
      department: "LTD", degree_program: "M.A.", other: "Temple", faculty_advisor: "Generic Advisor",
      degree_year: "First", personal_statement: "Personal Statement"
    }
  }

  it_behaves_like "email form"

end
