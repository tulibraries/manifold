class CreateLibraryHours < ActiveRecord::Migration[5.2]
  def change
    create_table :library_hours do |t|
      t.string :location
      t.datetime :date
      t.string :hours

      t.timestamps
    end
  end
end
