# frozen_string_literal: true

class AddGuidesFieldToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :libguides_account, :string
  end
end
