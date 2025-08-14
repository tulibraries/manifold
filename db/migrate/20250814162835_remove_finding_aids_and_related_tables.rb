# frozen_string_literal: true

class RemoveFindingAidsAndRelatedTables < ActiveRecord::Migration[7.2]
  def up
    # Remove foreign key constraints first
    remove_foreign_key :collection_aids, :finding_aids if foreign_key_exists?(:collection_aids, :finding_aids)
    remove_foreign_key :finding_aid_responsibilities, :finding_aids if foreign_key_exists?(:finding_aid_responsibilities, :finding_aids)
    remove_foreign_key :finding_aid_responsibilities, :people if foreign_key_exists?(:finding_aid_responsibilities, :people)
    
    # Drop the join tables
    drop_table :collection_aids if table_exists?(:collection_aids)
    drop_table :finding_aid_responsibilities if table_exists?(:finding_aid_responsibilities)
    
    # Drop the main table
    drop_table :finding_aids if table_exists?(:finding_aids)
  end

  def down
    # Recreate finding_aids table
    create_table :finding_aids do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.text :subject, array: true
      t.string :identifier
      t.integer :collection_id
      t.text :covid_alert
      t.boolean :draft, default: false
      t.boolean :holdover, default: false
      t.timestamps
    end
    
    add_index :finding_aids, :collection_id
    
    # Recreate join tables
    create_table :collection_aids do |t|
      t.integer :collection_id
      t.integer :finding_aid_id
      t.timestamps
    end
    
    add_index :collection_aids, :collection_id
    add_index :collection_aids, :finding_aid_id
    
    create_table :finding_aid_responsibilities do |t|
      t.integer :finding_aid_id
      t.integer :person_id
      t.timestamps
    end
    
    add_index :finding_aid_responsibilities, :finding_aid_id
    add_index :finding_aid_responsibilities, :person_id
  end
end
