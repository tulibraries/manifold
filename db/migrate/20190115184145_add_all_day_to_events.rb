# frozen_string_literal: true

class AddAllDayToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :all_day, :boolean, default: false
  end
end
