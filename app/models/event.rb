# frozen_string_literal: true

class Event < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable

  paginates_per 5
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true

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
        start_time.strftime("%l:%M %P") + " - " + end_time.strftime("%l:%M %P")
      else
        start_time.strftime("%l:%M %P")
      end
    else
      "(All day)"
    end
  end

  def label
    title
  end
end
