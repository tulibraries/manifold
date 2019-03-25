# frozen_string_literal: true

class UpdateFindingAidModel < ActiveRecord::Migration[5.2]
  def change
    change_column :finding_aids, :subject, :text
    add_column :finding_aids, :drupal_id, :string

    create_table :collection_aids do |t|
      t.belongs_to :collection, index: true
      t.belongs_to :finding_aid, index: true

      t.timestamps
    end
  end
end
