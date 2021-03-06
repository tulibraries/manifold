# frozen_string_literal: true

class Event < ApplicationRecord
  has_paper_trail
  include Categorizable
  include Imageable
  include InputCleaner
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  paginates_per 12
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true

  before_save :sanitize_description

  serialize :tags

  def to_param  # overridden for tests
    id
  end

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def get_tags
    self.tags.split(",").collect(&:strip) unless self.tags.nil?
  end

  def get_types
    self.event_type.split(",").collect(&:strip) unless self.event_type.nil?
  end

  def building_name
    building ? building.name : external_building
  end

  def building_address1
    building ? building.address1 : external_address
  end

  def building_address2
    building ? building.address2 : "#{external_city}, #{external_state} #{external_zip}"
  end

  def get_date
    start_time.strftime("%^a, %^b %d, %Y ").titleize unless start_time.nil?
  end

  def set_start_time
    unless all_day
      start_time.strftime("%l:%M %P")
    else
      "(All day)"
    end
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

  def schema_dot_org_type
    "Event"
  end

  def additional_schema_dot_org_attributes
    {
      eventStatus: ("http://schema.org/EventCancelled" if cancelled),
      startDate: start_time,
      endDate: end_time,
      location: {
        "@type" => "Place",
        name: building_name,
        address: {
          "@type" => "PostalAddress",
          streetAddress: building_address1,
          addressLocality: building_address2
        }
      }
    }
  end
end
