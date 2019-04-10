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

  def can_visit
    unless building.nil?
      true
    else
      false
    end
  end
  def get_date
    start_time.strftime("%B %d, %Y")
  end
  def set_times
    unless all_day
      "#{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
    else
      "All Day"
    end
  end

  def index_image
    image.variant(centered_image_variation(220, 220)).processed
  end

  def show_image
    image.variant(centered_image_variation(300, 300)).processed
  end

  def centered_image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: image.blob, gravity: "Center"))
  end
end
