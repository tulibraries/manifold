class AddSlugToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :slug, :string
  end
end
