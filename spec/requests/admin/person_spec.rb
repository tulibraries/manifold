# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person, type: :request do
  describe "GET /admin/people/:id/detach" do
    it "detaches image from people" do
      person = FactoryBot.create(:person, :with_image)
      login_as(FactoryBot.create(:administrator), scope: :account)

      get "/admin/people/#{person.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include("hal.png")

      get "/admin/people/#{person.id}/detach"
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to_not include("hal.png")
    end
  end
end
