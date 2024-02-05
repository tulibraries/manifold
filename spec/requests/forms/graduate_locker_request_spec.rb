# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charles Library Graduate Studio Locker Request", type: :request do

  let(:form_type) { "graduate-locker-request" }
  let(:the_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:title) { the_info.title }
  let(:recipients) { the_info.recipients }

  let(:form_params) {
    { form: {
      title:, form_type:, recipients: "[\"recipient@temple.edu\"]", name: "yes", email: "no@maybe.com", phone: "none", tu_id: "test_id", affiliation: "Graduate"
    } }
  }

  it_behaves_like "email form"

end
