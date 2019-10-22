# frozen_string_literal: true

class AddGuidToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :guid, :string
  end
end
