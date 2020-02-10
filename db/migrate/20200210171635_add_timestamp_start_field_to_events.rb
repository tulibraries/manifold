# frozen_string_literal: true

class AddTimestampStartFieldToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :timestamp_start, :string
  end
end
