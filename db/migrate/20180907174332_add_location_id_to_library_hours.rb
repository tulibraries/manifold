class AddLocationIdToLibraryHours < ActiveRecord::Migration[5.2]
  def change
    add_column :library_hours, :location_id, :string
  end
end
