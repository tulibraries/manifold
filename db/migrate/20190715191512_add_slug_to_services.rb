# frozen_string_literal: true

class AddSlugToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :slug, :string
  end
end
