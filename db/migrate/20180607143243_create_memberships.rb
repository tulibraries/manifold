class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :group, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
