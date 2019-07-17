# frozen_string_literal: true

require "rails_helper"

RSpec.describe Group, type: :request do
  describe "GET /admin/groups/:id/detach" do
    it "detaches image from groups" do
      group = FactoryBot.create(:group, :with_document)
      attach_id = group.documents_attachment_ids.first
      login_as(FactoryBot.create(:administrator), scope: :account)

      get "/admin/groups/#{group.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include("hal.png")

      get "/admin/groups/#{group.id}/detach?attach_id_param=#{attach_id}"
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to_not include("hal.png")
    end
  end
end
