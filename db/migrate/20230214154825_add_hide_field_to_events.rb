# frozen_string_literal: true

class AddHideFieldToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :suppress, :boolean, default: false
  end
end
