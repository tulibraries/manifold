# frozen_string_literal: true

class AddSlugToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :slug, :string
  end
end
