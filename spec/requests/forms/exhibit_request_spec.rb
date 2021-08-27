# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charles Library Exhibit Request", type: :request do

  let(:form_type) { "exhibit-request" }
  let(:form_params) {
    {
      name: "yes", email: "no@maybe.com", organizing_name: "none", exhibit_title: "Group name",
      exhibit_date_range: "false", description: "Reason for table and description of distributed materials",
      exhibit_location: "12/01/2000", exhibit_display_methods: "virtual", exhibit_funding_source: "Merill Lynch",
      exhibit_insurance: "The Prudential",
      exhibit_temple_connection: "yes", exhibit_temple_connection_description: "blah", exhibit_policies_acknowledgement: "yes"
    }
  }

  it_behaves_like "email form"

end
