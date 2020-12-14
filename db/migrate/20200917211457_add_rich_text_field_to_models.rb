# frozen_string_literal: true

class AddRichTextFieldToModels < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  unless table_exists?(:action_text_rich_texts)
    create_table :action_text_rich_texts do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.references :record, null: false, polymorphic: true, index: false

      t.timestamps

      t.index [ :record_type, :record_id, :name ], name: "index_action_text_rich_texts_uniqueness", unique: true
    end
  end

  # entities = [:alerts, :buildings, :categories, :collections, :events, :exhibitions, :finding_aids, :groups, :policies, :services, :spaces, :webpages]

  # entities.each do |e|

  #   model = e.to_s.classify.constantize
  #   instance = e.to_s.downcase.singularize

  #   change_table e, bulk: true do |t|
  #     def up
  #       rename_column e, :description, :description_old if column_exists?(e, :description) && model != "Category"
  #       rename_column e, :long_description, :long_description_old if column_exists?(e, :long_description)
  #       rename_column e, :access_description, :access_description_old if column_exists?(e, :access_description)
  #       rename_column e, :get_help, :get_help_old if column_exists?(e, :get_help)
  #       rename_column e, :covid_alert, :covid_alert_old if column_exists?(e, :covid_alert)

  #       model.find_each do |a|
  #         a.update_attributes(description: a.description_old) if column_exists?(a, :description)
  #         a.update_attributes(access_description: a.access_description_old) if column_exists?(a, :access_description)
  #         a.update_attributes(get_help: a.get_help_old) if column_exists?(a, :get_help)
  #         a.update_attributes(covid_alert: a.covid_alert_old) if column_exists?(a, :covid_alert)
  #       end

  #       remove column e, :description_old if column_exists?(e, :description_old)
  #       remove column e, :access_description_old if column_exists?(e, :access_description_old)
  #       remove column e, :get_help_old if column_exists?(e, :get_help_old)
  #       remove column e, :covid_alert_old if column_exists?(e, :covid_alert_old)
  #     end

  #     def down
  #       add_column e, :description_new, :text if e.get_attributes.key?(description) && model != "Category"
  #       add_column e, :long_description_new, :text if e.get_attributes.key?(long_description)
  #       add_column e, :access_description_new, :text if e.get_attributes.key?(access_description)
  #       add_column e, :get_help_new, :text if e.get_attributes.key?(get_help)
  #       add_column e, :get_help_new, :text if e.get_attributes.key?(covid_alert)

  #       model.find_each do |a|
  #         a.update(description_new: a.description.body.to_html) if a.description.body.present? && model != "Category"
  #         a.update(description_new: a.long_description.body.to_html) if a.long_description.body.present?
  #         a.update(description_new: a.access_description.body.to_html) if a.access_description.body.present?
  #         a.update(description_new: a.get_help.body.to_html) if a.get_help.body.present?
  #         a.update(description_new: a.covid_alert.body.to_html) if a.covid_alert.body.present?
  #       end

  #       rename_column t.description_new, :description if t.description_new
  #       rename_column t.access_description_new, :access_description if t.description_new
  #       rename_column t.get_help_new, :get_help if t.description_new
  #       rename_column t.covid_alert_new, :covid_alert if t.covid_alert_new
  #     end
  #   end
  # end

  change_table :alerts, bulk: true do |t|
    def up
      rename_column :alerts, :description, :description_old
      rename_column :alerts, :draft_description, :draft_description_old
    end
  end

  change_table :buildings, bulk: true do |t|
    def up
      rename_column :buildings, :description, :description_old
      rename_column :buildings, :draft_description, :draft_description_old
      rename_column :buildings, :covid_alert, :covid_alert_old
    end
  end

  change_table :categories, bulk: true do |t|
    def up
      rename_column :categories, :long_description, :long_description_old
      rename_column :categories, :draft_long_description, :draft_long_description_old
      rename_column :categories, :get_help, :get_help_old
      rename_column :categories, :covid_alert, :covid_alert_old
    end
  end

  change_table :collections, bulk: true do |t|
    def up
      rename_column :collections, :description, :description_old
      rename_column :collections, :draft_description, :draft_description_old
      rename_column :collections, :covid_alert, :covid_alert_old
    end
  end

  change_table :events, bulk: true do |t|
    def up
      rename_column :events, :description, :description_old
      rename_column :events, :draft_description, :draft_description_old
    end
  end

  change_table :exhibitions, bulk: true do |t|
    def up
      rename_column :exhibitions, :description, :description_old
      rename_column :exhibitions, :draft_description, :draft_description_old
      rename_column :exhibitions, :covid_alert, :covid_alert_old
    end
  end

  change_table :finding_aids, bulk: true do |t|
    def up
      rename_column :finding_aids, :description, :description_old
      rename_column :finding_aids, :draft_description, :draft_description_old
      rename_column :finding_aids, :covid_alert, :covid_alert_old
    end
  end

  change_table :groups, bulk: true do |t|
    def up
      rename_column :groups, :description, :description_old
      rename_column :groups, :draft_description, :draft_description_old
    end
  end

  change_table :policies, bulk: true do |t|
    def up
      rename_column :policies, :description, :description_old
      rename_column :policies, :draft_description, :draft_description_old
      rename_column :policies, :covid_alert, :covid_alert_old
    end
  end

  change_table :services, bulk: true do |t|
    def up
      rename_column :services, :description, :description_old
      rename_column :services, :draft_description, :draft_description_old
      rename_column :services, :access_description, :access_description_old
      rename_column :services, :draft_access_description, :draft_access_description_old
      rename_column :services, :covid_alert, :covid_alert_old
    end
  end

  change_table :spaces, bulk: true do |t|
    def up
      rename_column :spaces, :description, :description_old
      rename_column :spaces, :draft_description, :draft_description_old
      rename_column :spaces, :covid_alert, :covid_alert_old
    end
  end

  change_table :webpages, bulk: true do |t|
    def up
      rename_column :webpages, :description, :description_old
      rename_column :webpages, :draft_description, :draft_description_old
      rename_column :webpages, :covid_alert, :covid_alert_old
    end
  end
end
