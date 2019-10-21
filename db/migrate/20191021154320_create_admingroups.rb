# frozen_string_literal: true

class CreateAdmingroups < ActiveRecord::Migration[5.2]
  def change
    create_table :admingroups do |t|
      t.string :name

      t.timestamps
    end
  end
end
