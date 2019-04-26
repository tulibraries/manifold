# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImagesController, type: :controller do
  let(:person) { FactoryBot.create(:person, :with_image) }

  describe "thumbnail_image" do
    it "redirect to parent image blob path" do
      get :thumbnail_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

  describe "medium_image" do
    it "redirect to parent image blob path" do
      get :medium_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

  describe "large_image" do
    it "redirect to parent image blob path" do
      pending "Failing with mogrify error though same image works in browser for this method"
      get :large_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

end
