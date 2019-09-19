# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Partners Borrowing Privileges Application/Renewal", type: :request do

  let(:form_type) { "partners-borrowing" }
  let(:form_params) {
    {
      name: "Ultra Man", email: "staff@temple.edu", tu_id: "1234567890",
      partner_name: "Gargantua Reptilius", partner_email: "gargo@hotmail.com"
    }
  }

  it_behaves_like "email form"

end
