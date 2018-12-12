# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::BlogPost", type: :request do
  before(:all) do
    @account = FactoryBot.create(:account)
    @blog_post = FactoryBot.build(:blog_post)
    @blog_post.save!
  end

  before(:each) do
    sign_in @account
  end

  after(:each) do
    sign_out @account
  end

  describe "GET /admin/blog_posts/s" do
    it "access blog_post adminstrate" do
      get admin_blog_posts_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(@blog_post.title)
    end
  end

  describe "GET /admin/blog_posts/show" do
    it "show blog_post" do
      get [admin_blogs_path, @blog_post.id.to_s].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/blog_posts/edit" do
    it "show blog_post" do
      get [admin_blog_posts_path, @blog_post.id.to_s, "edit"].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/blog_posts/new" do
    it "show blog_post" do
      get [admin_blog_posts_path, "new"].join("/")
      expect(response).to have_http_status(200)
    end
  end
end
