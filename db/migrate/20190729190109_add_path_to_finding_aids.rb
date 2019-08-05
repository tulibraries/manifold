# frozen_string_literal: true

class AddPathToFindingAids < ActiveRecord::Migration[5.2]
  def change
    add_column :finding_aids, :path, :string
  end
end
