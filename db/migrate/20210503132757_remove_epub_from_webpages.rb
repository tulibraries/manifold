# frozen_string_literal: true

class RemoveEpubFromWebpages < ActiveRecord::Migration[6.1]
  def change
    remove_column :webpages, :epub, :string
  end
end
