# frozen_string_literal: true

class AddLibcalCategoriesToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :libcal_categories, :text
  end
end
