# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesHelper, type: :helper do
  before :all do
    @policy = FactoryBot.create(:policy)
    @category = FactoryBot.create(:category, name: "policy")
  end

  describe "category_url" do
    it "is the first category" do
      expect(helper.category_url).to match /^http:\/\/test.host\/policies\/#{Category.first.to_param}$/
    end
  end
  describe "category_path" do
    it "is the first category" do
      expect(helper.category_path).to match /^\/policies\/#{Category.first.to_param}$/
    end
  end
end
