# frozen_string_literal: true

require "rails_helper"

RSpec.describe "app/views/finding_aids/_aid_list.html.erb", type: :view do

  context "A finding aid without a name is present (not allowed anymore)" do
    it "does not error out" do
      FactoryBot.create(:finding_aid)

      aids_list = FindingAid.all.page 1
      aids_list[0].name = nil

      instance_variable_set("@aids_list", aids_list)
      expect { render(partial: "finding_aids/aid_list") }.not_to raise_error
    end
  end
end
