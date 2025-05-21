# frozen_string_literal: true

class AddAltTextExternalLinks < ActiveRecord::Migration[7.2]
  def up
    add_column :external_links, :image_alt_text, :string
  end
  def down
    remove_column :external_links, :image_alt_text
  end
end
