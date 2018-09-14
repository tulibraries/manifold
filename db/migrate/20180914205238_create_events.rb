class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :blurb
      t.string :link
      t.date :date
      t.time :time
      t.string :type
      t.string :tags

      t.timestamps
    end
  end
end
