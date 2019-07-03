# frozen_string_literal: true

class AddExternalLinkToCollections < ActiveRecord::Migration[5.2]
  def change
    add_reference :collections, :external_link, foreign_key: true
  end
end
