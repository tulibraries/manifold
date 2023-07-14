# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogPostsController, type: :controller do
  describe "GET #index" do
    let(:blogpost) { FactoryBot.create(:blog_post) }

    it "returns http success with tags" do
      get :index, params: { tags: blogpost.categories }
      expect(response).to have_http_status(:found)
    end

    it "redirects if no tag param" do
      get :index
      response.should redirect_to "/news"
    end
  end
end
