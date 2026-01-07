# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "delete restricted" do |associations|

  let(:model) { associations.keys.first } # the class that includes the concern
  let(:model_name) { model.to_s.underscore }
  let!(:factory_model) { FactoryBot.create(model) }
  let(:exception) { ActiveRecord::DeleteRestrictionError.new(model_name) }
  let!(:associated_models) { [] }
  let(:account) { FactoryBot.create(:account, role: "admin") }
  let(:undeletables) { :event }

  before do
    associations.values.first.each do |association|
      associated_models << FactoryBot.create(association, "#{model_name}_id".to_sym => factory_model.id)
    end
  end

  describe "delete restriction" do
    it "does not allow deletion when associations present" do
      associated_models.each do |associated_model|
        expect { factory_model.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
    it "displays a custom error message" do
      visit "/admin/#{model_name.pluralize}"
      page.find("tr[data-url='/admin/#{model_name.pluralize}/#{factory_model.label.parameterize}']").first(:link, "Destroy").click
      expect(page).to have_current_path("/admin/#{model_name.pluralize}")
      associated_models.each do |associated_model|
        expect(page).to have_link(associated_model.label)
      end
    end
  end
end
