# frozen_string_literal: true

class AddRichTextFieldToModels < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  change_table :alerts, bulk: true do |t|
    def up
      Alert.find_each do |alert|
        alert.update(description: alert.description_old)
        alert.update(draft_description: alert.draft_description_old)
      end
      remove_column :alerts, :description_old
      remove_column :alerts, :draft_description_old
    end
  end

  change_table :buildings, bulk: true do |t|
    def up
      Building.find_each do |building|
        building.update(description: building.description_old)
        building.update(draft_description: building.draft_description_old)
        building.update(covid_alert: building.covid_alert_old)
      end

      remove_column :buildings, :description_old
      remove_column :buildings, :draft_description_old
      remove_column :buildings, :covid_alert_old
    end
  end

  change_table :categories, bulk: true do |t|
    def up
      Category.find_each do |category|
        category.update(long_description: category.long_description_old)
        category.update(draft_long_description: category.draft_long_description_old)
        category.update(get_help: category.get_help_old)
        category.update(draft_get_help: category.draft_get_help_old)
        category.update(covid_alert: category.covid_alert_old)
      end

      remove_column :categories, :long_description_old
      remove_column :categories, :draft_long_description_old
      remove_column :categories, :get_help_old
      remove_column :categories, :draft_get_help_old
      remove_column :categories, :covid_alert_old
    end
  end

  change_table :collections, bulk: true do |t|
    def up
      Collection.find_each do |collection|
        collection.update(description: collection.description_old)
        collection.update(draft_description: collection.draft_description_old)
        collection.update(covid_alert: collection.covid_alert_old)
      end

      remove_column :collections, :description_old
      remove_column :collections, :draft_description_old
      remove_column :collections, :covid_alert_old
    end
  end

  change_table :events, bulk: true do |t|
    def up
      Event.find_each do |event|
        event.update(description: event.description_old)
        event.update(draft_description: event.draft_description_old)
      end

      remove_column :events, :description_old
      remove_column :events, :draft_description_old
    end
  end

  change_table :exhibitions, bulk: true do |t|
    def up
      Exhibition.find_each do |exhibition|
        exhibition.update(description: exhibition.description_old)
        exhibition.update(draft_description: exhibition.draft_description_old)
        exhibition.update(covid_alert: exhibition.covid_alert_old)
      end

      remove_column :exhibitions, :description_old
      remove_column :exhibitions, :draft_description_old
      remove_column :exhibitions, :covid_alert_old
    end
  end

  change_table :finding_aids, bulk: true do |t|
    def up
      FindingAid.find_each do |finding_aid|
        finding_aid.update(description: finding_aid.description_old)
        finding_aid.update(draft_description: finding_aid.draft_description_old)
        finding_aid.update(covid_alert: finding_aid.covid_alert_old)
      end

      remove_column :finding_aids, :description_old
      remove_column :finding_aids, :draft_description_old
      remove_column :finding_aids, :covid_alert_old
    end
  end

  change_table :groups, bulk: true do |t|
    def up
      Group.find_each do |group|
        group.update(description: group.description_old)
        group.update(draft_description: group.draft_description_old)
      end

      remove_column :groups, :description_old
      remove_column :groups, :draft_description_old
    end
  end

  change_table :policies, bulk: true do |t|
    def up
      Policy.find_each do |policy|
        policy.update(description: policy.description_old)
        policy.update(draft_description: policy.draft_description_old)
        policy.update(covid_alert: policy.covid_alert_old)
      end

      remove_column :policies, :description_old
      remove_column :policies, :draft_description_old
      remove_column :policies, :covid_alert_old
    end
  end

  change_table :services, bulk: true do |t|
    def up
      Service.find_each do |service|
        service.update(description: service.description_old)
        service.update(draft_description: service.draft_description_old)
        service.update(access_description: service.access_description_old)
        service.update(draft_access_description: service.draft_access_description_old)
        service.update(covid_alert: service.covid_alert_old)
      end

      remove_column :services, :description_old
      remove_column :services, :draft_description_old
      remove_column :services, :access_description_old
      remove_column :services, :draft_access_description_old
      remove_column :services, :covid_alert_old
    end
  end

  change_table :spaces, bulk: true do |t|
    def up
      Space.find_each do |space|
        space.update(description: space.description_old)
        space.update(draft_description: space.draft_description_old)
        space.update(covid_alert: space.covid_alert_old)
      end

      remove_column :spaces, :description_old
      remove_column :spaces, :draft_description_old
      remove_column :spaces, :covid_alert_old
    end
  end

  change_table :webpages, bulk: true do |t|
    def up
      Webpage.find_each do |webpage|
        webpage.update(description: webpage.description_old)
        webpage.update(draft_description: webpage.draft_description_old)
        webpage.update(covid_alert: webpage.covid_alert_old)
      end

      remove_column :webpages, :description_old
      remove_column :webpages, :draft_description_old
      remove_column :webpages, :covid_alert_old
    end
  end
end
