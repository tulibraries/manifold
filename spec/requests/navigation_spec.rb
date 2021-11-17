# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Navigation Spec", type: :request do

  describe "Navigation should be available" do
    it "should show the navigation on the home page" do
      @cta3 = FactoryBot.create(:category, slug: "about-page")
      @cta4 = FactoryBot.create(:category, slug: "about-page")
      @webpage = FactoryBot.create(:webpage, categories: [@cta3, @cta4])
      get webpage_path(@webpage.id)
      expect(response).to render_template(:show)
    end
  end
end
