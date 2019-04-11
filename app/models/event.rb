# frozen_string_literal: true

class Event < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable

  paginates_per 5
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true
  has_one_attached :image, dependent: :destroy

  before_save :sanitize_description

  serialize :tags

  def get_tags
    self.tags.split(",").collect(&:strip)
  end
  def get_types
    self.event_type.split(",").collect(&:strip)
  end

  def building_name(event)
    if event.building
      event.building.name
    else
      event.external_building
    end
  end

  def can_visit
    unless building.nil?
      true
    else
      false
    end
  end

  def get_date
    start_time.strftime("%^A, %^B %d, %Y ").titleize
  end

  def set_times
    unless all_day
      unless end_time.nil? || end_time == start_time
        start_time.strftime("%l:00 %P") + " - " + end_time.strftime("%l:00 %P")
      else
        start_time.strftime("%l:00 %P")
      end
    else
      "(All day)"
    end
  end

  def index_image
    variation =
      ActiveStorage::Variation.new(Uploads.resize_to_fill(width: 220, height: 220, blob: image.blob, gravity: "Center"))
    ActiveStorage::Variant.new(image.blob, variation)
  end
  def show_image
    variation =
      ActiveStorage::Variation.new(Uploads.resize_to_fill(width: 220, height: 220, blob: image.blob, gravity: "Center"))
    ActiveStorage::Variant.new(image.blob, variation)
  end
end
