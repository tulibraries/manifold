# frozen_string_literal: true

class UpdateGroupsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :groups, bulk: true do |t|
      rename_column :groups, :description, :description_old

      Group.find_each do |group|
        group.update(description: group.description_old)
      end

      remove_column :groups, :description_old
    end
  end

  def down
    change_table :groups, bulk: true do |t|
      add_column :groups, :description_new, :text

      Group.find_each do |group|
        group.update(description_new: group.description.body.to_html) if group.description.body.present?
      end

      rename_column :groups, :description_new, :description
    end
  end
end
