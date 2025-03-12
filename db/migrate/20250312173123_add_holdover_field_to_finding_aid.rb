# frozen_string_literal: true

class AddHoldoverFieldToFindingAid < ActiveRecord::Migration[7.2]
  def change
    add_column :finding_aids, :holdover, :boolean, default: false
  end
end
