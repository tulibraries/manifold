# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImagesController, type: :controller do
  let(:person) { FactoryBot.create(:person, :with_image) }

  describe "thumbnail_image" do
    it "redirect to parent image blob path" do
      # Instatiate person and sleep because the factory attaches the image
      # after the person is created, and these tests were causing a race condition
      person
      sleep(2)
      get :thumbnail_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

  describe "medium_image" do
    it "redirect to parent image blob path" do
      # Instatiate person and sleep because the factory attaches the image
      # after the person is created, and these tests were causing a race condition
      person
      sleep(2)
      get :medium_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

  describe "large_image" do
    it "redirect to parent image blob path" do
      # Instatiate person and sleep because the factory attaches the image
      # after the person is created, and these tests were causing a race condition
      person
      sleep(2)
      get :large_image, params:  { person_id: person.id }
      expect(response).to have_http_status 302
    end
  end

end
