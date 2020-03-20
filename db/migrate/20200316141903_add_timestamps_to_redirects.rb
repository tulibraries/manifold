# frozen_string_literal: true

class AddTimestampsToRedirects < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :redirects, bulk: true do |t|
        dir.up do
          t.datetime :created_at
          t.datetime :updated_at

        end

        dir.down do
          t.remove :created_at
          t.remove :updated_at
        end
      end
    end
  end
end
