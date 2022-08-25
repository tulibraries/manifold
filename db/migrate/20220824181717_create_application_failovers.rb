class CreateApplicationFailovers < ActiveRecord::Migration[6.1]
  def change
    create_table :application_failovers do |t|
      t.boolean :turn_on, default: false
      t.timestamps
    end
  end
end
