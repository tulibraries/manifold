# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Library Book Home Delivery Request Form", type: :request do

  let(:form_type) { "home-delivery" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients:, name: "Pat Reader", tu_id: "915000000", email: "reader@temple.edu",
      street_address: "123 Main Street", apartment_unit: "Apt 4B", city_state_zip: "Lancaster, PA 17601",
      book_title: "Test Book Title", author: "Test Author",
      library_search_link: "https://librarysearch.temple.edu/catalog/991000000000003811",
      return_agreement: "1", damage_responsibility: "1"
    } }
  }

  it_behaves_like "email form"

  it "renders the section titles and distance note" do
    get("/forms/#{form_type}")
    expect(response.body).to include("Patron Information", "Mailing Address", "Book Request Details",
                                      "Terms and Policies", "at least 40 miles from Main Campus")
  end
end
