class MigrateCategoryFieldsToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :categories, :long_description, :long_description_old
    rename_column :categories, :get_help, :get_help_old
    rename_column :categories, :covid_alert, :covid_alert_old
    
    Category.find_each do |category|
      category.update_attribute(:long_description, simple_format(category.long_description_old))
      category.update_attribute(:get_help, simple_format(category.get_help_old))
      category.update_attribute(:covid_alert, simple_format(category.covid_alert_old))
    end

    remove_column :categories, :long_description_old
    remove_column :categories, :get_help_old
    remove_column :categories, :covid_alert_old
  end
end
