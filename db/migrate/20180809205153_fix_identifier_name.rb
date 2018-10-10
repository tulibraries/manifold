# frozen_string_literal: true

class FixIdentifierName < ActiveRecord::Migration[5.2]
  def change
    rename_column :people, :identifier, :research_identifier
  end
end
