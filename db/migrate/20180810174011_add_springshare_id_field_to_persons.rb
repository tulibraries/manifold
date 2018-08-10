class AddSpringshareIdFieldToPersons < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :springshare_id, :string
  end
end
