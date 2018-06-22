class CreateSpacesPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces_people do |t|
      t.references :space, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
