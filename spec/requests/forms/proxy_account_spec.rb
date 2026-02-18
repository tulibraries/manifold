# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Proxy Account", type: :request do

  let(:form_type) { "proxy-account" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients:, name: "proxy", email: "to_proxy@temple.edu", tu_id: "999999999",
      proxy_name: "Proxy Name", proxy_tuid: "Proxy TUid number", proxy_account_email: "proxy@temple.edu"
    } }
  }

  it_behaves_like "email form"

end
