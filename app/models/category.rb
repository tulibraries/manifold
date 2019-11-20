# frozen_string_literal: true

class Category < ApplicationRecord
  include Accountable
  include Imageable

  has_many :categorizations, dependent: :destroy
  accepts_nested_attributes_for :categorizations

  has_many :nested_categorizations, as: :categorizable, dependent: :destroy, class_name: "Categorization"
  has_many :categories, through: :nested_categorizations

  belongs_to :external_link, optional: true

  validates :name, presence: true

  # Because many types of Models can be categorized into a
  # single category, we need a way to return a single list of those objects.
  # Rather than making a SQL call per item, we group them by type (Buildings, Events, etc)
  # and then send a single SQL request per type.
  # If the limit_to parameter is provided, it limits the response
  # to items of that Class
  # eg @category.items(limit_to: [:events]) would
  def items(limit_to: [], exclude: [])
    grouped = categorizations.group_by(&:categorizable_type)

    if limit_to.present?
      grouped.select! { |ct, _ | limit_to.include?(ct.underscore.to_sym)  }
    end

    if exclude.present?
      grouped.reject! { |ct, _ | exclude.include?(ct.underscore.to_sym)  }
    end

    grouped.map do |type, objs|
      ids = objs.map(&:categorizable_id)
      weights = objs.map(&:weight)
      type.constantize.find(ids)
        .each_with_index { |obj, index| obj.category_weight = weights[index]  }
    end.reduce([], :concat)
      .sort_by { |categorized| [categorized&.category_weight, categorized&.label] }
  end

  def link
    custom_url.present? ? custom_url : self
  end
end
