class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :title
      t.text :description
      t.text :access_description
      t.string :access_link
      t.text :service_policies
      t.text :intended_audience
      t.string :service_category

      t.timestamps
    end
  end
end
