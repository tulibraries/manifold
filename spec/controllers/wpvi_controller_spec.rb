# frozen_string_literal: true

require "rails_helper"

RSpec.describe WpviController, type: :controller do
  include AuthHelper

  before(:each) do
    http_login
  end

  describe "GET #show" do
    it "returns a success response" do
      expect(response).to be_success
    end
  end

  describe "GET #search" do
    it "returns a success response" do
      expect(response).to be_success
    end
  end
end
