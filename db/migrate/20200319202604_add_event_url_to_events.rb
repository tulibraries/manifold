# frozen_string_literal: true

class AddEventUrlToEvents < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        add_column :events, :event_url, :string
      end
      dir.down do
        remove_column :events, :event_url
      end
    end
  end
end
