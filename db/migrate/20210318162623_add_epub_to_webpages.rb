# frozen_string_literal: true

class AddEpubToWebpages < ActiveRecord::Migration[6.1]
  def change
    unless column_exists? :webpages, :epub
      add_column :webpages, :epub, :string
    end
  end
end
