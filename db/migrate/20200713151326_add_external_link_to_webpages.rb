# frozen_string_literal: true

class AddExternalLinkToWebpages < ActiveRecord::Migration[5.2]
  def change
    add_reference :webpages, :external_link, foreign_key: true
  end
end
