# frozen_string_literal: true

class UpdatePoliciesForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :policies, bulk: true do |t|
      rename_column :policies, :description, :description_old
      rename_column :policies, :covid_alert, :covid_alert_old

      Policy.find_each do |policy|
        policy.update(description: policy.description_old)
        policy.update(covid_alert: policy.covid_alert_old)
      end

      remove_column :policies, :description_old
      remove_column :policies, :covid_alert_old
    end
  end

  def down
    change_table :policies, bulk: true do |t|
      add_column :policies, :description_new, :text
      add_column :policies, :covid_alert_new, :text

      Policy.find_each do |policy|
        policy.update(description_new: policy.description.body.to_html) if policy.description.body.present?
        policy.update(covid_alert_new: policy.covid_alert.body.to_html) if policy.covid_alert.body.present?
      end

      rename_column :policies, :description_new, :description
      rename_column :policies, :covid_alert_new, :covid_alert
    end
  end
end
