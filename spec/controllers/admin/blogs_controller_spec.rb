# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Admin::BlogsController, type: :controller do
  # Verify edit page for non-versioned model

  before(:each) do
    account = FactoryBot.create(:account, role: "admin")
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
    let (:blog) { FactoryBot.create(:blog) }
    before do
      # Stub out the syn service so we don't actually make
      # http requests for rss. We jut want to test that
      # we are calling the service integration correctly
      allow(SyncService::Blogs).to receive(:new)
        .and_return(OpenStruct.new(sync_blog_posts: nil))
    end
    it "renders edit form" do

      post :sync, params: { blog_id: blog.id }
      expect(response).to redirect_to admin_blogs_path
    end
  end
end
