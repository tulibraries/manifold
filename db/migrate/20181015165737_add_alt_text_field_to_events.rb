# frozen_string_literal: true

class AddAltTextFieldToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :alt_text, :string
  end
end
