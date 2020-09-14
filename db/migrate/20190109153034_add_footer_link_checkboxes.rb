# frozen_string_literal: true

class AddFooterLinkCheckboxes < ActiveRecord::Migration[5.2]
  def up
    add_column :buildings, :add_to_footer, :boolean
    add_column :services, :add_to_footer, :boolean
    add_column :groups, :add_to_footer, :boolean
    add_column :collections, :add_to_footer, :boolean
  end
  def down
    add_column :buildings, :add_to_footer, :boolean
    add_column :services, :add_to_footer, :boolean
    add_column :groups, :add_to_footer, :boolean
    add_column :collections, :add_to_footer, :boolean
  end
end
