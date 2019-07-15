class AddSlugToExternalLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :external_links, :slug, :string
  end
end
