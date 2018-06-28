class CreateSpacePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :space_people do |t|
      t.references :space, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
