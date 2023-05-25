class CreateAlertsJsons < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts_jsons do |t|
      t.text :message

      t.timestamps
    end
  end
end
