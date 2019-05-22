# frozen_string_literal: true

class AddExternalLinkToServices < ActiveRecord::Migration[5.2]
  def change
    add_reference :services, :external_link, foreign_key: true
  end
end
