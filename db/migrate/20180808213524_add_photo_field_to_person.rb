# frozen_string_literal: true

class AddPhotoFieldToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :photo, :string
  end
end
