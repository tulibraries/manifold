# frozen_string_literal: true

class AddSlugToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :slug, :string
  end
end
