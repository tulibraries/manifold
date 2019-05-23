# frozen_string_literal: true

class AddExternalLinkToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_reference :buildings, :external_link, foreign_key: true
  end
end
