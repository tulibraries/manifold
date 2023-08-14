# frozen_string_literal: true

class CreateFormInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :form_infos do |t|
      t.string :title
      t.text :recipients, array: true, default: []
      t.string :slug

      t.timestamps
    end
  end
end
