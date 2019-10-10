# frozen_string_literal: true

class AddWeightToCategorizations < ActiveRecord::Migration[5.2]
  def change
    add_column :categorizations, :weight, :integer, default: 10
  end
end
