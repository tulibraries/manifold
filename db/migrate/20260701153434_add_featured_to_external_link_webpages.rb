# frozen_string_literal: true

class AddFeaturedToExternalLinkWebpages < ActiveRecord::Migration[8.1]
  def change
    add_column :external_link_webpages, :featured, :boolean, default: false
  end
end
