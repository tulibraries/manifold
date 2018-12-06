# frozen_string_literal: true

class AddSpecialtiesFieldToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :specialties, :string
  end
end
