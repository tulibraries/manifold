# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Blog", type: :request do
  before(:all) do
    @account = FactoryBot.create(:account)
    @blog = FactoryBot.build(:blog)
    @blog.save!
    @blog_post = FactoryBot.build(:blog_post, blog: @blog)
  end

  before(:each) do
    sign_in @account
  end

  after(:each) do
    sign_out @account
  end

  describe "GET /admin/blogs" do
    it "access blog adminstrate" do
      get admin_blogs_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(@blog.title)
    end
  end

  describe "GET /admin/blogs/show" do
    it "show blog" do
      get [admin_blogs_path, @blog.id.to_s].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/blogs/edit" do
    it "show blog" do
      get [admin_blogs_path, @blog.id.to_s, "edit"].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/blogs/new" do
    it "show blog" do
      get [admin_blogs_path, "new"].join("/")
      expect(response).to have_http_status(200)
    end
  end
end
