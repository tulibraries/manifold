# frozen_string_literal: true

class UpdateSlugFieldsForFriendlyId < ActiveRecord::Migration[5.2]
  def change
    change_column :buildings, :slug, :string, unique: true
    change_column :categories, :slug, :string, unique: true
    change_column :collections, :slug, :string, unique: true
    change_column :events, :slug, :string, unique: true
    change_column :external_links, :slug, :string, unique: true
    change_column :pages, :slug, :string, unique: true
    change_column :policies, :slug, :string, unique: true
    change_column :services, :slug, :string, unique: true
    change_column :spaces, :slug, :string, unique: true
    change_column :blogs, :slug, :string, unique: true
    add_column :people, :slug, :string, unique: true
    add_column :finding_aids, :slug, :string, unique: true
    add_column :groups, :slug, :string, unique: true
    add_column :exhibitions, :slug, :string, unique: true
    add_column :highlights, :slug, :string, unique: true
  end
end
