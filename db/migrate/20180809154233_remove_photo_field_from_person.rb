# frozen_string_literal: true

class RemovePhotoFieldFromPerson < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :photo, :string
  end
end
