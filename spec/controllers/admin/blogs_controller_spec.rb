# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::BlogsController, type: :controller do
  # Verify edit page for non-versioned model

  before(:each) do
    account = FactoryBot.create(:account, admin: true)
    sign_in(account)
  end

  describe "GET #sync_all" do
    render_views true
    it "renders edit form" do

      post :sync_all
      expect(response).to redirect_to admin_blogs_path
    end
  end

  describe "GET #sync" do
    let (:blog) { FactoryBot.create(:blog)}
    render_views true
    it "renders edit form" do
      post :sync, params: { blog_id: blog.id }
      expect(response).to redirect_to admin_blogs_path
    end
  end
end
