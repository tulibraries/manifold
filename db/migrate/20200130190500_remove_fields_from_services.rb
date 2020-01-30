# frozen_string_literal: true

class RemoveFieldsFromServices < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :services, bulk: true do |t|
        dir.up do
          t.remove :service_category
          t.remove :add_to_footer
          t.remove :access_link
        end

        dir.down do
          t.string :service_category
          t.boolean :add_to_footer
          t.string :access_link
        end
      end
    end
  end
end
