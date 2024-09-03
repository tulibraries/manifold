# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonsHelper, type: :helper do
  describe "Get location name" do
    let(:building) { FactoryBot.create(:building) }

    it "returns person's location" do
      expect(helper.get_loc_name(building.id)).to eql building.name
    end
  end

  describe "Get department name" do
    let(:group) { FactoryBot.create(:group) }

    it "returns department" do
      expect(helper.get_dept_name(group.id)).to eql group.name
    end
  end

  describe "default request for staff index" do
    it "returns default show link" do
      expect(helper.specialists_link).to have_text t("manifold.people.filters.limit_to_specialists")
    end
  end

  describe "request for all specialists page" do
    it "returns limited message" do
      controller.params[:specialists] = true
      expect(helper.specialists_link).to eql t("manifold.people.filters.limited_to_specialists")
    end
  end

  describe "request for a specialty page" do
    it "returns see all message" do
      controller.params[:specialty] = "archeology"
      expect(helper.specialists_link).to have_text t("manifold.people.filters.see_all_specialists")
    end
  end

  describe "print_specialists" do
    it "returns link to full print list" do
      controller.params[:specialists] = true
      expect(helper.print_specialists).to include specialists_print_path
    end
    it "returns link to departmental print list" do
      controller.params[:specialists] = true
      controller.params[:department] = "health-sciences-library-staff"
      expect(helper.print_specialists).to include specialists_print_path(dept: "health-sciences-library-staff")
    end
  end

end
