# frozen_string_literal: true

class UpdateSpacesForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
    
  def up
    rename_column :spaces, :description, :description_old
    rename_column :spaces, :covid_alert, :covid_alert_old

    Space.find_each do |space|
      space.update(description: space.description_old)
      space.update(covid_alert: space.covid_alert_old)
    end

    remove_column :spaces, :description_old
    remove_column :spaces, :covid_alert_old
  end

  def down
    add_column :spaces, :description_new, :text
    add_column :spaces, :covid_alert_new, :text

    Space.find_each do |space|
      space.update(description_new: space.description.body.to_html) if space.description.body.present?
      space.update(covid_alert_new: space.covid_alert.body.to_html) if space.covid_alert.body.present?
    end

    rename_column :spaces, :description_new, :description
    rename_column :spaces, :covid_alert_new, :covid_alert
  end
end
