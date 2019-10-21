# frozen_string_literal: true

class AddAdminGroupToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :admin_group, foreign_key: true
  end
end
