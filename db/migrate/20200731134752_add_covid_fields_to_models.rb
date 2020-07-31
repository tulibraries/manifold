# frozen_string_literal: true

class AddCovidFieldsToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :covid_alert, :string
    add_column :categories, :covid_alert, :string
    add_column :collections, :covid_alert, :string
    add_column :exhibitions, :covid_alert, :string
    add_column :finding_aids, :covid_alert, :string
    add_column :policies, :covid_alert, :string
    add_column :services, :covid_alert, :string
    add_column :spaces, :covid_alert, :string
    add_column :webpages, :covid_alert, :string

    add_column :alerts, :for_header, :boolean
  end
end
