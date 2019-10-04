class CreateWpvis < ActiveRecord::Migration[5.2]
  def change
    create_table :wpvis do |t|

      t.timestamps
    end
  end
end
