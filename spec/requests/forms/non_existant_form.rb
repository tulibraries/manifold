# frozen_string_literal: true

require "rails_helper"

RSpec.describe "A Form that doesn't exist", type: :request do

  let(:form_type) { "nopasaurus-rex" }

  it "404's" do
    get "/forms/#{form_type}"
    expect(response.status).to eql(404)
  end
end
