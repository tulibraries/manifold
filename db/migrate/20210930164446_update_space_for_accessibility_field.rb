# frozen_string_literal: true

class UpdateSpaceForAccessibilityField < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :spaces, bulk: true do |t|
      rename_column :spaces, :accessibility, :accessibility_old

      Space.find_each do |space|
        space.update(accessibility: space.accessibility_old)
      end

      remove_column :spaces, :accessibility_old
    end
  end

  def down
    change_table :spaces, bulk: true do |t|
      add_column :space, :accessibility_new, :text

      Space.find_each do |space|
        space.update(accessibility_new: space.accessibility.body.to_html) if space.accessibility.body.present?
      end

      rename_column :spaces, :accessibility_new, :accessibility
    end
  end
end
