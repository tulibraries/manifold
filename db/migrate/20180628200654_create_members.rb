class CreateGroupPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :group_people do |t|
      t.references :group, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
