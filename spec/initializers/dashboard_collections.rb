# frozen_string_literal: true

require "rails_helper"


RSpec.describe "dashboard_collections initializer" do

  context "setting a dashboard selector collection" do

    it "sets the group types" do
      expect(Rails.configuration.group_types).to include "Department"
      expect(Rails.configuration.group_types).to include "Committee"
    end

  end

end
