# frozen_string_literal: true

require "rails_helper"

RSpec.describe MenuGroup, type: :model do
  describe "Associations" do
    it { should have_many(:categories).through(:menu_group_categories) }
  end
end
