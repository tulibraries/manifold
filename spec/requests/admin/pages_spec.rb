# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Page", type: :request do
  before(:all) do
    @account = FactoryBot.create(:account)
    @page = FactoryBot.build(:page)
    @page.save!
  end

  before(:each) do
    sign_in @account
  end

  after(:each) do
    sign_out @account
  end

  describe "GET /admin/pages" do
    it "access page adminstrate" do
      get admin_pages_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(@page.title)
    end
  end

  describe "GET /admin/pages/show" do
    it "show page" do
      get [admin_pages_path, @page.id.to_s].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/pages/edit" do
    it "show page" do
      get [admin_pages_path, @page.id.to_s, "edit"].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/pages/new" do
    it "show page" do
      get [admin_pages_path, "new"].join("/")
      expect(response).to have_http_status(200)
    end
  end
end
