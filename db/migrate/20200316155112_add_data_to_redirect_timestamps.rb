# frozen_string_literal: true

class AddDataToRedirectTimestamps < ActiveRecord::Migration[5.2]
  def change
    Redirect.all.each do |redirect|
      redirect.with_lock do
        begin
          redirect.created_at = Time.zone.today
          redirect.save!
        rescue StandardError => e
          @log.send(:info, "#{redirect.class.name}: #{redirect.legacy_path} -- #{e.message}")
          next
        end
      end
    end

    reversible do |dir|
      change_table :redirects, bulk: true do |t|
        dir.up do
          change_column :redirects, :created_at, :datetime, null: false
          change_column :redirects, :updated_at, :datetime, null: false
        end

        dir.down do
          change_column :redirects, :created_at, :datetime, null: true
          change_column :redirects, :updated_at, :datetime, null: true
        end
      end
    end
  end
end
