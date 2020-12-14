# frozen_string_literal: true

class UpdateEventsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def change
    change_table :events, bulk: true do |ev|
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
  end
end
