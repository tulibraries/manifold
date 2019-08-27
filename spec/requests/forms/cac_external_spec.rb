# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cultural Analytics Certificate External Application", type: :request do

  let(:form_type) { "cac-external" }
  let(:form_params) {
    {
      name: "Ringo", email: "tu@temple.edu", phone: "2152041234", bachelor_degree: "Yes",
      institution_of_degree: "Temple", overall_gpa: "4.0", degrees_earned: "None",
      comments: "Personal Statement"
    }
  }

  it_behaves_like "email form"

end
