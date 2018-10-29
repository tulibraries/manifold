# frozen_string_literal: true

class AddAlertabilityToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :alertability, :boolean
  end
end
