class AddPromotedFieldToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :promoted, :boolean
  end
end
