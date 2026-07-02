# frozen_string_literal: true

class AddFeaturedToFileabilities < ActiveRecord::Migration[8.1]
  def change
    add_column :fileabilities, :featured, :boolean, default: false
  end
end
