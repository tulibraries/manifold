class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.string :title
      t.text :blurb
      t.string :link
      t.date :date
      t.time :time
      t.string :type_of_highlight
      t.string :tags
      t.boolean :promoted
      t.type :string

      t.timestamps
    end
  end
end
