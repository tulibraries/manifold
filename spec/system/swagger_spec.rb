# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Swager", type: :system do

  before(:all) do
    FactoryBot.create(:person)
  end

  context "Swagger Spec File" do
    paths = JSON.load(Rails.root.join("swagger/swagger.json"))["paths"].keys
    paths.each do |path|
      scenario "Visit #{path}" do
        visit("#{path}.json")
        expect { JSON.load(page.html) }.not_to raise_error
      end
    end
  end
end
