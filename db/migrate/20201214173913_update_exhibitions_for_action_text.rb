# frozen_string_literal: true

class UpdateExhibitionsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :exhibitions, bulk: true do |t|
      rename_column :exhibitions, :description, :description_old
      rename_column :exhibitions, :covid_alert, :covid_alert_old

      Exhibition.find_each do |exhibition|
        exhibition.update(description: exhibition.description_old)
        exhibition.update(covid_alert: exhibition.covid_alert_old)
      end

      remove_column :exhibitions, :description_old
      remove_column :exhibitions, :covid_alert_old
    end
  end

  def down
    change_table :exhibitions, bulk: true do |t|
      add_column :exhibitions, :description_new, :text
      add_column :exhibitions, :covid_alert_new, :text

      Exhibition.find_each do |exhibition|
        exhibition.update(description_new: exhibition.description.body.to_html) if exhibition.description.body.present?
        exhibition.update(covid_alert_new: exhibition.covid_alert.body.to_html) if exhibition.covid_alert.body.present?
      end

      rename_column :exhibitions, :description_new, :description
      rename_column :exhibitions, :covid_alert_new, :covid_alert
    end
  end
end
