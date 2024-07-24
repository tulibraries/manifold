class DropHoursTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :library_hours
  end
end
