# frozen_string_literal: true

class AddTutorialPathFieldToWebpages < ActiveRecord::Migration[6.1]
  def up
    add_column :webpages, :tutorial_path, :string
  end
  def down
    remove_column :webpages, :tutorial_path
  end
end
