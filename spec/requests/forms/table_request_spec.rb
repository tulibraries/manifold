# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Library Staff and Registered Student Organization Table Request", type: :request do

  let(:form_type) { "table-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients.to_s }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients:, name: "yes", email: "no@maybe.com", phone: "none", group: "Group name",
      easel: "false", comments: "Reason for table and description of distributed materials",
      preferred_date: "12/01/2000", preferred_time: "15:00"
    } }
  }

  it_behaves_like "email form"

end
