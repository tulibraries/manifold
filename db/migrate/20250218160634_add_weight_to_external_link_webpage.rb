# frozen_string_literal: true

class AddWeightToExternalLinkWebpage < ActiveRecord::Migration[7.2]
  def change
    add_column :external_link_webpages, :weight, :integer, default: 10
  end
end
