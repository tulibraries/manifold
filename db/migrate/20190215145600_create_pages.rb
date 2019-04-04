# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :description
      t.string :layout
      t.references :group, foreign_key: true
      t.timestamps
    end
  end
end
