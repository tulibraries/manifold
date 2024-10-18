# frozen_string_literal: true

class AddOnlineFieldToExhibitions < ActiveRecord::Migration[7.0]
  def up
    add_column :exhibitions, :online_url, :string
  end
  def down
    remove_column :exhibitions, :online_url, :string
  end
end
