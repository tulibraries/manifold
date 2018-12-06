# frozen_string_literal: true

class AddEnsembleIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :ensemble_identifier, :string
  end
end
