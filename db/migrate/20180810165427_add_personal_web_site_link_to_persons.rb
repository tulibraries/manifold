# frozen_string_literal: true

class AddPersonalWebSiteLinkToPersons < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :personal_site, :string
  end
end
