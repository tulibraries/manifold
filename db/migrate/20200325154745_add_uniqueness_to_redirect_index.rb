# frozen_string_literal: true

class AddUniquenessToRedirectIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :redirects, :legacy_path
    add_index :redirects, :legacy_path, unique: true
  end
end
