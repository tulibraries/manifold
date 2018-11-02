# frozen_string_literal: true

class CreatePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :policies do |t|
      t.string     :name
      t.text       :description
      t.date       :effective_date
      t.date       :expiration_date
      t.references :policies, :policy_makeable, polymorphic: true

      t.timestamps
    end
  end
end
