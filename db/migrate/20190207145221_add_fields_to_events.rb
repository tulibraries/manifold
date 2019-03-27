# frozen_string_literal: true

class AddFieldsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_type, :string
    add_column :exhibitions, :promoted_to_events, :boolean
  end
end
