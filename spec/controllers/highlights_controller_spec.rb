# frozen_string_literal: true

require "rails_helper"

RSpec.describe HighlightsController, type: :controller do

  let(:highlight) { FactoryBot.create(:highlight) }

  describe "json response" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

end
