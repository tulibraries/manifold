# frozen_string_literal: true

require "rails_helper"

RSpec.feature "People", type: :feature do
  # [TODO] remove this spec after all person-specialties fields are cleaned up

  describe "Specialties List" do
    before(:all) do
      @person = FactoryBot.create(:person)
      visit "/people/#{@person.id}"
    end

    scenario "User views staff specialties on desktop" do
      Capybara.current_session.driver.browser.manage.window.resize_to(1280, 1024) if Capybara.current_session.driver.browser.respond_to? "manage"
      expect(page.all(:xpath, "div.subject-list/div.list-unstyled/li", exact_text: "first subject")).to be
      expect(page.all(:xpath, "div.subject-list/div.list-unstyled/li", exact_text: "").count).to eq(0)
    end

    scenario "User views staff specialties on mobile" do
      Capybara.current_session.driver.browser.manage.window.resize_to(720, 640) if Capybara.current_session.driver.browser.respond_to? "manage"
      expect(page.all(:xpath, "div.subject-list/div.list-unstyled/li", exact_text: "first subject")).to be
      expect(page.all(:xpath, "div.subject-list/div.list-unstyled/li", exact_text: "").count).to eq(0)
    end
  end

  describe "Index Page" do
    before(:all) do
      @person1 = FactoryBot.create(:person)
      @person2 = FactoryBot.create(:person, specialties: ["Specialty1"], first_name: "Test1")
      visit "/people"
    end

    scenario "Test for Subjects" do
      within("//*[@id='subjects']") do
        click_on "Specialty1"
      end
      expect(page.all(:xpath, "//*[@class='row person']").count).to eq(1)
    end
  end
end
