# frozen_string_literal: true

class RemovePhoneAndEmailFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :phone_number, :string
    remove_column :groups, :email_address, :string
  end
end
