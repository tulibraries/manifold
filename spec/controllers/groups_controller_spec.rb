# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:group) { FactoryBot.create(:group) }

  describe "GET #index" do
    xit "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

end
