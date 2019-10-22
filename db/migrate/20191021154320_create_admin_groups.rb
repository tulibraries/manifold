# frozen_string_literal: true

class CreateAdminGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
