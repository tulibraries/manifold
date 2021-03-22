# frozen_string_literal: true

class AddEpubToWebpages < ActiveRecord::Migration[6.1]
  def change
    add_column :webpages, :epub, :string
  end
end
