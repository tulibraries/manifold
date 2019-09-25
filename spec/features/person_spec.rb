# frozen_string_literal: true

require "rails_helper"

RSpec.feature "People", type: :feature do
  # [TODO] remove this spec after all person-specialties fields are cleaned up

  describe "Show Page Specialties" do
    before(:each) do
      @person = FactoryBot.create(:person)
      visit "/people/#{@person.id}"
    end

    after(:each) do
      Person.delete_all
    end

    scenario "User views staff specialties on desktop" do
      Capybara.current_session.driver.browser.manage.window.resize_to(1280, 1024) if Capybara.current_session.driver.browser.respond_to? "manage"
      expect(page.all("div.subject-list/ul.list-unstyled/li", exact_text: "first subject")).to be
      expect(page.all("div.subject-list/ul.list-unstyled/li", exact_text: "").count).to eq(0)
    end

    scenario "User views staff specialties on mobile" do
      Capybara.current_session.driver.browser.manage.window.resize_to(720, 640) if Capybara.current_session.driver.browser.respond_to? "manage"
      expect(page.all("div.subject-list/ul.list-unstyled/li", exact_text: "first subject")).to be
      expect(page.all("div.subject-list/ul.list-unstyled/li", exact_text: "").count).to eq(0)
    end
  end

  describe "Index Page" do
    # Capybara.ignore_hidden_elements = false
    before(:each) do
      space = FactoryBot.create(:space, name: "Location1")
      @person1 = FactoryBot.create(:person)
      @person2 = FactoryBot.create(:person, specialties: ["Specialty1"], first_name: "Test1", spaces: [space])
      #Application.eager_load!
      visit people_path
    end

    after(:each) do
      Person.delete_all
      Space.delete_all
    end

    scenario "Test for All Staff" do
      expect(page.all(:xpath, "//*[@class='row person']", visible: false).count).to eq(2)
      # This should return 3 rows of this class because a print page.html show three, errors finding 0
    end

    scenario "Test for Subjects" do
      expect(page).to have_xpath("//*[@id='subjects']")
      within(:css, "ul#subjects", match: :first) do
        click_on "Specialty1"
      end
      expect(page.all(:xpath, "//*[@class='row person']").count).to eq(1)
    end

    scenario "Test for location" do
      expect(page).to have_xpath("//*[@id='locations']")
      within(:css, "ul#locations", match: :first) do
        click_on "Location1"
      end
      expect(page.all(:xpath, "//*[@class='row person']").count).to eq(1)
    end

    Capybara.ignore_hidden_elements = true
  end
end
