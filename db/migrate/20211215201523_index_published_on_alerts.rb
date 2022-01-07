# frozen_string_literal: true

class IndexPublishedOnAlerts < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:alerts, :published)
      add_index :alerts, :published
    end
  end
end
