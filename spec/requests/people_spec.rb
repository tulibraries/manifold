# frozen_string_literal: true

require "rails_helper"

RSpec.describe "People", type: :request do

  Subject.destroy_all
  let(:person) { FactoryBot.create(:person, :with_image) }
  let(:person2) { FactoryBot.create(:person, :with_image) }
  let(:group) { FactoryBot.create(:group, persons: [person2]) }
  let!(:specialist) { FactoryBot.create(:person, :with_image, :with_subjects, :in_department) }

  describe "People Views" do
    it "renders the index page" do
      get people_path
      expect(response).to render_template(:index)
      expect(response.body).to include(specialist.label)
    end

    it "renders the specialists" do
      get people_path, params: { specialty: Subject.last.name }
      expect(response.body).to include(specialist.label)
      expect(response.body).not_to include(person.label)
    end

    it "renders the specialists within a dept" do
      get people_path, params: { specialists: true, department: specialist.groups.first.slug }
      expect(response.body).to include(specialist.label)
      expect(response.body).not_to include(person.label)
    end

    it "filters department present" do
      get people_path, params: { department: group.friendly_id }
      expect(response.body).to include(person2.label)
      expect(response.body).not_to include(person.label)
    end

    it "filter by search term" do
      get people_path, params: { search: person2.name }
      expect(response.body).to include(person2.label)
      expect(response.body).not_to include(person.label)
    end

    it "renders the show page" do
      get person_path(person)
      expect(response).to render_template(:show)
      expect(response.body).to include(person.label)
    end

    it "renders the all-specialists print page" do
      get specialists_print_path
      expect(response).to render_template(:specialists_print)
      expect(response.body).to include(specialist.label)
      expect(response.body).not_to include(person.label)
    end

    it "renders the departmental print page" do
      get specialists_print_path(dept: specialist.groups.first.slug)
      expect(response).to render_template(:specialists_print)
      expect(response.body).to include(specialist.label)
      expect(response.body).not_to include(person.label)
    end
  end
end
