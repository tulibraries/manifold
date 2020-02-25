# frozen_string_literal: true

class AddExternalLinkToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :external_link, foreign_key: true
  end
end
