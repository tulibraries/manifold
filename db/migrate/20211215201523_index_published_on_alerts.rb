# frozen_string_literal: true

class IndexPublishedOnAlerts < ActiveRecord::Migration[6.1]
  def change
    add_index :alerts, :published
  end
end
