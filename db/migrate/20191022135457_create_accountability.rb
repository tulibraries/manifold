# frozen_string_literal: true

class CreateAccountability < ActiveRecord::Migration[5.2]
  def change
    create_table :accountabilities do |t|
      t.references :accountable, polymorphic: true, index: false
      t.references :account
      t.timestamps
    end

    add_index :accountabilities,
     [:account_id, :accountable_id, :accountable_type],
     name: "polymorphic_accountability",
     unique: true
  end
end
