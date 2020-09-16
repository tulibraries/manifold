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
  
        Alert.find_each do |alert|
          alert.update_attributes(description: alert.description_old)
        end
  
        remove_column :alerts, :description_old
      end
  
      def down
        add_column :alerts, :description_new, :text
  
        Alert.find_each do |alert|
          alert.update(description_new: alert.description.body.to_html) if alert.description.body.present?
        end
  
        rename_column :alerts, :description_new, :description
      end
    end
  
  
    change_table :buildings, bulk: true do |t|
      def up
        rename_column :buildings, :description, :description_old
        rename_column :buildings, :covid_alert, :covid_alert_old
  
        Building.find_each do |building|
          building.update(description: building.description_old)
          building.update(covid_alert: building.covid_alert_old)
        end
  
        remove_column :buildings, :description_old
        remove_column :buildings, :covid_alert_old
      end
  
      def down
        add_column :buildings, :description_new, :text
        add_column :buildings, :covid_alert_new, :text
  
        Building.find_each do |building|
          building.update(description_new: building.description.body.to_html) if building.description.body.present?
          building.update(covid_alert_new: building.covid_alert.body.to_html) if building.covid_alert.body.present?
        end
  
        rename_column :buildings, :description_new, :description
        rename_column :buildings, :covid_alert_new, :covid_alert
      end
    end
  
    change_table :categories, bulk: true do |t|
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
  
    change_table :collections, bulk: true do |t|
      def up
        rename_column :collections, :description, :description_old
        rename_column :collections, :covid_alert, :covid_alert_old
  
        Collection.find_each do |collection|
          collection.update(description: collection.description_old)
          collection.update(covid_alert: collection.covid_alert_old)
        end
  
        remove_column :collections, :description_old
        remove_column :collections, :covid_alert_old
      end
  
      def down
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
    
    change_table :events, bulk: true do |t|
      def up
        rename_column :events, :description, :description_old
  
        Event.find_each do |event|
          event.update(description: event.description_old)
        end
  
        remove_column :events, :description_old
      end
  
      def down
        add_column :events, :description_new, :text
  
        Event.find_each do |event|
          event.update(description_new: event.description.body.to_html) if event.description.body.present?
        end
  
        rename_column :events, :description_new, :description
      end
    end
  
    change_table :exhibitions, bulk: true do |t|
      def up
        rename_column :exhibitions, :description, :description_old
        rename_column :exhibitions, :covid_alert, :covid_alert_old
  
        Exhibition.find_each do |exhibition|
          exhibition.update(description: exhibition.description_old)
          exhibition.update(covid_alert: exhibition.covid_alert_old)
        end
  
        remove_column :exhibitions, :description_old
        remove_column :exhibitions, :covid_alert_old
      end
  
      def down
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
  
    change_table :finding_aids, bulk: true do |t|
      def up
        rename_column :finding_aids, :description, :description_old
        rename_column :finding_aids, :covid_alert, :covid_alert_old
  
        FindingAid.find_each do |finding_aid|
          finding_aid.update(description: finding_aid.description_old)
          finding_aid.update(covid_alert: finding_aid.covid_alert_old)
        end
  
        remove_column :finding_aids, :description_old
        remove_column :finding_aids, :covid_alert_old
      end
  
      def down
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
  
    change_table :groups, bulk: true do |t|
      def up
        rename_column :groups, :description, :description_old
  
        Group.find_each do |group|
          group.update(description: group.description_old)
        end
  
        remove_column :groups, :description_old
      end
  
      def down
        add_column :groups, :description_new, :text
  
        Group.find_each do |group|
          group.update(description_new: group.description.body.to_html) if group.description.body.present?
        end
  
        rename_column :groups, :description_new, :description
      end
    end
  
    change_table :policies, bulk: true do |t|
      def up
        rename_column :policies, :description, :description_old
        rename_column :policies, :covid_alert, :covid_alert_old
  
        Policy.find_each do |policy|
          policy.update(description: policy.description_old)
          policy.update(covid_alert: policy.covid_alert_old)
        end
  
        remove_column :policies, :description_old
        remove_column :policies, :covid_alert_old
      end
  
      def down
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
  
    change_table :services, bulk: true do |t|
      def up
        rename_column :services, :description, :description_old
        rename_column :services, :access_description, :access_description_old
        rename_column :services, :covid_alert, :covid_alert_old
  
        Service.find_each do |service|
          service.update(description: service.description_old)
          service.update(access_description: service.access_description_old)
          service.update(covid_alert: service.covid_alert_old)
        end
  
        remove_column :services, :description_old
        remove_column :services, :access_description_old
        remove_column :services, :covid_alert_old
      end
  
      def down
        add_column :services, :description_new, :text
        add_column :services, :access_description_new, :text
        add_column :services, :covid_alert_new, :text
  
        Service.find_each do |service|
          service.update(description_new: service.description.body.to_html) if service.description.body.present?
          service.update(access_description_new: service.access_description.body.to_html) if service.access_description.body.present?
          service.update(covid_alert_new: service.covid_alert.body.to_html) if service.covid_alert.body.present?
        end
  
        rename_column :services, :description_new, :description
        rename_column :services, :access_description_new, :access_description
        rename_column :services, :covid_alert_new, :covid_alert
      end
    end
  
    change_table :spaces, bulk: true do |t|
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
  
    change_table :webpages, bulk: true do |t|
      def up
        rename_column :webpages, :description, :description_old
        rename_column :webpages, :covid_alert, :covid_alert_old
  
        Webpage.find_each do |webpage|
          webpage.update(description: webpage.description_old)
          webpage.update(covid_alert: webpage.covid_alert_old)
        end
  
        remove_column :webpages, :description_old
        remove_column :webpages, :covid_alert_old
      end
  
      def down
        add_column :webpages, :description_new, :text
        add_column :webpages, :covid_alert_new, :text
  
        Webpage.find_each do |webpage|
          webpage.update(description_new: webpage.description.body.to_html) if webpage.description.body.present?
          webpage.update(covid_alert_new: webpage.covid_alert.body.to_html) if webpage.covid_alert.body.present?
        end
  
        rename_column :webpages, :description_new, :description
        rename_column :webpages, :covid_alert_new, :covid_alert
      end
    end
  
  end
  