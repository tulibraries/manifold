# frozen_string_literal: true

class UpdateFindingAidModel < ActiveRecord::Migration[5.2]
  def change
    change_table :finding_aids, bulk: true do |t|
      t.column :finding_aids, :text
      t.column :subject, :text
      t.string :drupal_id
    end

    create_table :collection_aids do |t|
      t.belongs_to :collection, index: true
      t.belongs_to :finding_aid, index: true

      t.timestamps
    end
  end
end
