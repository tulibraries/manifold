# frozen_string_literal: true

class CreateServiceGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :service_groups do |t|
      t.references :service, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
