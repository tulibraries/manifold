# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Partners Borrowing Privileges Application/Renewal", type: :request do

  let(:form_type) { "partners-borrowing" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "Ultra Man", email: "staff@temple.edu", tu_id: "1234567890",
      partner_name: "Gargantua Reptilius", partner_email: "gargo@hotmail.com"
    }
  }

  it_behaves_like "email form"

end
