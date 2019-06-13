# frozen_string_literal: true

class AddExternalLinkToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_reference :spaces, :external_link, foreign_key: true
  end
end
