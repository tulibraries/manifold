# frozen_string_literal: true

class CreateMenuGroups < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:menu_groups)
      create_table :menu_groups do |t|
        t.string :title
        t.string :slug

        t.timestamps
      end
    end
  end
end
