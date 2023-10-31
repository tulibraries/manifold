# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WebpagesController, type: :controller do

  before(:all) do
    @account = FactoryBot.create(:account)
  end

  describe "GET #edit" do
    render_views true
    before do
      sign_in(@account)
      @webpage = FactoryBot.create(:webpage, :with_file)
      @webpage.update!(title: "page saved")
    end

    it "renders edit form with updated values by default" do
      get :edit, params: { id: @webpage.to_param }
      expect(response.body).to match("page saved")
    end

    it "saves with file removed" do
      @webpage.update!(file_uploads: [])
      get :edit, params: { id: @webpage.to_param }
      expect(response).to be_successful
    end
  end
end
