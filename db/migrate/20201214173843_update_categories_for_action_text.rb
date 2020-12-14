# frozen_string_literal: true

class UpdateCategoriesForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    rename_column :categories, :long_description, :long_description_old
    rename_column :categories, :get_help, :get_help_old
    rename_column :categories, :covid_alert, :covid_alert_old

    Category.find_each do |category|
      category.update(long_description: category.long_description_old)
      category.update(get_help: category.get_help_old)
      category.update(covid_alert: category.covid_alert_old)
    end

    remove_column :categories, :long_description_old
    remove_column :categories, :get_help_old
    remove_column :categories, :covid_alert_old
  end

  def down
    add_column :categories, :long_description_new, :text
    add_column :categories, :get_help_new, :text
    add_column :categories, :covid_alert_new, :text

    Category.find_each do |category|
      category.update(long_description_new: category.long_description.body.to_html) if category.long_description.present?
      category.update(get_help_new: category.get_help.body.to_html) if category.get_help.body.present?
      category.update(covid_alert_new: category.covid_alert.body.to_html) if category.covid_alert.body.present?
    end

    rename_column :categories, :long_description_new, :long_description
    rename_column :categories, :get_help_new, :get_help
    rename_column :categories, :covid_alert_new, :covid_alert
  end
end
