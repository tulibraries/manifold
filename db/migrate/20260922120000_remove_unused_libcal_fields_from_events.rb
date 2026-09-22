# frozen_string_literal: true

class RemoveUnusedLibcalFieldsFromEvents < ActiveRecord::Migration[8.1]
  def change
    change_table :events, bulk: true do |t|
      t.remove :contact_phone, type: :string
      t.remove :registration_status, type: :boolean
      t.remove :cancelled, type: :boolean
    end
  end
end
