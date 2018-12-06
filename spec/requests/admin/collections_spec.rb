# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Collections", type: :request do
  before(:all) do
    @account = FactoryBot.create(:account)
    @collection = FactoryBot.build(:collection)
    @collection.save!
  end

  before(:each) do
    sign_in @account
  end

  after(:each) do
    sign_out @account
  end

  describe "GET /admin/collections" do
    it "access collection adminstrate" do
      get admin_collections_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(@collection.name)
    end
  end

  describe "GET /admin/collections/show" do
    it "show collection" do
      get [admin_collections_path, @collection.id.to_s].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/collections/edit" do
    it "show collection" do
      get [admin_collections_path, @collection.id.to_s, "edit"].join("/")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/collections/new" do
    it "show collection" do
      get [admin_collections_path, "new"].join("/")
      expect(response).to have_http_status(200)
    end
  end
end
