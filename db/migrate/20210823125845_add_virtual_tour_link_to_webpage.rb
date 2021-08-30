# frozen_string_literal: true

class AddVirtualTourLinkToWebpage < ActiveRecord::Migration[6.1]
  def change
    add_column :webpages, :virtual_tour, :string
  end
end
