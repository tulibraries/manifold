# frozen_string_literal: true

class AddNoMessageFieldToRedirects < ActiveRecord::Migration[5.2]
  def change
    add_column :redirects, :no_message, :boolean
  end
end
