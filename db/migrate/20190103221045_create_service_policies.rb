# frozen_string_literal: true

class CreateServicePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :service_policies do |t|
      t.references :service, foreign_key: true
      t.references :policy, foreign_key: true

      t.timestamps
    end
  end
end
