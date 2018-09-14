class ChangeTypeNameOnHighlights < ActiveRecord::Migration[5.2]
  def change
  	rename_column :highlights, :type, :highlight_type
  end
end
