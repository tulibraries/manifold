# frozen_string_literal: true

class AddCategoryFieldToPolicies < ActiveRecord::Migration[5.2]
  def change
    add_column :policies, :category, :string
  end
end
