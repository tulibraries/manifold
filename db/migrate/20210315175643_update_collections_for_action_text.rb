# frozen_string_literal: true

class UpdateCollectionsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :collections, bulk: true do |t|
      rename_column :collections, :description, :description_old
      rename_column :collections, :covid_alert, :covid_alert_old

      Collection.find_each do |collection|
        collection.update(description: collection.description_old)
        collection.update(covid_alert: collection.covid_alert_old)
      end

      remove_column :collections, :description_old
      remove_column :collections, :covid_alert_old
    end
  end

  def down
    change_table :colletions, bulk: true do |t|
      add_column :collections, :description_new, :text
      add_column :collections, :covid_alert_new, :text

      Collection.find_each do |collection|
        collection.update(description_new: collection.description.body.to_html) if collection.description.body.present?
        collection.update(covid_alert_new: collection.covid_alert.body.to_html) if collection.covid_alert.body.present?
      end

      rename_column :collections, :description_new, :description
      rename_column :collections, :covid_alert_new, :covid_alert
    end
  end
end
