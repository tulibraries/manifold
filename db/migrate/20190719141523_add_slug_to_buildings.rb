# frozen_string_literal: true

class AddSlugToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :slug, :string
  end
end
