# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Proxy Account", type: :request do

  let(:form_type) { "proxy-account" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients: "[\"recipient@temple.edu\"]", faculty_admin_name: "Faculty/Administrator Name", faculty_admin_email: "Faculty/Administrator Email",
      faculty_admin_tuid: "Faculty/Administrator TUid number", proxy_name: "Proxy Name",
      proxy_tuid: "Proxy TUid number", proxy_account_expiration: "12/01/2042"
    } }
  }

  it_behaves_like "email form"

end
