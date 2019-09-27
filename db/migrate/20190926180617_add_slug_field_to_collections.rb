# frozen_string_literal: true

class AddSlugFieldToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :slug, :string
  end
end
