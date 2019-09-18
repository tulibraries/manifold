# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charles Library Graduate Studio Locker Request", type: :request do

  let(:form_type) { "graduate-locker-request" }
  let(:form_params) {
    {
      name: "yes", email: "no@maybe.com", phone: "none", tu_id: "test_id", affiliation: "Graduate"
    }
  }

  it_behaves_like "email form"

end
