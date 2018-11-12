class CreatePolicyApplications < ActiveRecord::Migration[5.2]
  def change

    create_table :policies do |t|
      t.string :name
      t.text :description
  end

    create_table :policy_applications do |t|
      t.references :policyable, polymorphic: true, index: false
      t.references :policy
      t.timestamps
      t.index [ :policyable_type, :policyable_id, :policy_id ], name: "index_uniqueness_policy_application", unique: true
    end
  end
end
