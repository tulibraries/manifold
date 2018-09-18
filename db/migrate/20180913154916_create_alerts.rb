class CreateAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      t.string :scroll_text
      t.string :link
      t.text :description
      t.boolean :published

      t.timestamps
    end
  end
end
