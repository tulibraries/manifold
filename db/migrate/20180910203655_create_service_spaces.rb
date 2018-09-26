class CreateServiceSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :service_spaces do |t|
      t.references :service, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
