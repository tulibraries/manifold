# frozen_string_literal: true

require "rails_helper"

RSpec.describe Categorization, type: :model do
  it "can have a building as a categorizable" do
    building = FactoryBot.build(:building)
    category = FactoryBot.build(:category)
    expect { Categorization.create!(category:, categorizable: building) }.not_to raise_error
  end

  it "can have a category as a categorizable" do
    category = FactoryBot.build(:category)
    parent_category = FactoryBot.build(:category_parent)
    expect {
        Categorization.create!(
          category:,
          categorizable: parent_category)
      }.not_to raise_error
  end
end
