# frozen_string_literal: true

class AddAdmingroupToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :admingroup, foreign_key: true
  end
end
