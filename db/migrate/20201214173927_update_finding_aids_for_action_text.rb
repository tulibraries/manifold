# frozen_string_literal: true

class UpdateFindingAidsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :finding_aids, bulk: true do |t|
      rename_column :finding_aids, :description, :description_old
      rename_column :finding_aids, :covid_alert, :covid_alert_old

      FindingAid.find_each do |finding_aid|
        finding_aid.update(description: finding_aid.description_old)
        finding_aid.update(covid_alert: finding_aid.covid_alert_old)
      end

      remove_column :finding_aids, :description_old
      remove_column :finding_aids, :covid_alert_old
    end
  end

  def down
    change_table :finding_aids, bulk: true do |t|
      add_column :finding_aids, :description_new, :text
      add_column :finding_aids, :covid_alert_new, :text

      FindingAid.find_each do |finding_aid|
        finding_aid.update(description_new: finding_aid.description.body.to_html) if finding_aid.description.body.present?
        finding_aid.update(covid_alert_new: finding_aid.covid_alert.body.to_html) if finding_aid.covid_alert.body.present?
      end

      rename_column :finding_aids, :description_new, :description
      rename_column :finding_aids, :covid_alert_new, :covid_alert
    end
  end
end
