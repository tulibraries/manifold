# frozen_string_literal: true

class Category < ApplicationRecord
  include Rails.application.routes.url_helpers
  #TODO: should we validate that icon is svg?
  has_many :categorizations, dependent: :destroy

  has_many :nested_categorizations, as: :categorizable, dependent: :destroy, class_name: "Categorization"
  has_many :categories, through: :nested_categorizations

  has_one_attached :icon

  validates :name, presence: true

  # Because many types of Models can be categorized into a
  # single category, we need a way to return a single list of those objects.
  # Rather than making a SQL call per item, we group them by type (Buildings, Events, etc)
  # and then send a single SQL request per type.
  def items
    categorizations.group_by(&:categorizable_type).
      map do |type, objs|
        ids = objs.map(&:categorizable_id)
        type.constantize.find(ids)
      end.reduce([], :concat)
  end

  def url(only_path: false)
    if custom_url
      custom_url
    elsif items.first
      polymorphic_url(items.first, only_path: only_path)
    else
      root_url
    end
  end

  def path
    url(only_path: true)
  end
end
