# frozen_string_literal: true

class AddFieldsToExhibitions < ActiveRecord::Migration[8.1]
  def change
    add_column :exhibitions, :alt_text, :string
    change_column_default :exhibitions, :promoted_to_events, from: nil, to: false
  end
end
