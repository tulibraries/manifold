# frozen_string_literal: true

class AddFieldsToExhibitions < ActiveRecord::Migration[8.1]
  def change
    change_table :exhibitions, bulk: true do |t|
      t.string :alt_text
      t.change_default :promoted_to_events, from: nil, to: false
    end
  end
end
