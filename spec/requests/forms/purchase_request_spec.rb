# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Purchase Request", type: :request do

  let(:form_type) { "purchase-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    {
      title:, recipients:, name: "x",
      email: "x@x.com",
      phone: "x",
      tu_id: "x",
      department: "x",
      affiliation: "x",
      material_type: "x",
      material_type_other: "x",
      author: "x",
      book_title: "x",
      year: "x",
      publisher: "x",
      format_preference: "x",
      source_of_information: "x",
      comments: "x"
    }
  }

  it_behaves_like "email form"

end
