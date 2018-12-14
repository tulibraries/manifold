# frozen_string_literal: true

class Event < ApplicationRecord
  include InputCleaner
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true
  has_one_attached :image, dependent: :destroy

  before_save :sanitize_description

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
    unless start_time == "(All day)"
      "#{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
    else
      start_time
    end
  end
end
