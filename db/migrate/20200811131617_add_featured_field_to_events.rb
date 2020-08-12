# frozen_string_literal: true

class AddFeaturedFieldToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :featured, :boolean
  end
end
