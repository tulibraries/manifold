# frozen_string_literal: true

class AddLibguidesAccountToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :libguides_account, :string
  end
end
