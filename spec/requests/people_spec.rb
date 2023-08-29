# frozen_string_literal: true

require "rails_helper"

RSpec.describe "People", type: :request do

  context "People Views" do
    it "renders the index page" do
      person = FactoryBot.create(:person, :with_image)
      specialist = FactoryBot.create(:person, :with_image, :with_subjects)
      get people_path
      expect(response).to render_template(:index)
      expect(response.body).to include(specialist.label)
    end

    it "renders the show page" do
      person = FactoryBot.create(:person, :with_image)
      specialist = FactoryBot.create(:person, :with_image, :with_subjects)
      get person_path(person)
      expect(response).to render_template(:show)
      expect(response.body).to include(person.label)
    end

    it "renders the print page" do
      person = FactoryBot.create(:person, :with_image)
      specialist = FactoryBot.create(:person, :with_image, :with_subjects)
      get specialists_print_path
      expect(response).to render_template(:specialists_print)
      expect(response.body).to include(specialist.label)
      expect(response.body).not_to include(person.label)
    end
  end
end
