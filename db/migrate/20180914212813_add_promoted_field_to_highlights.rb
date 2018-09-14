class AddPromotedFieldToHighlights < ActiveRecord::Migration[5.2]
  def change
    add_column :highlights, :promoted, :boolean
  end
end
