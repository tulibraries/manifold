# frozen_string_literal: true

class Event < ApplicationRecord
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

  has_rich_text :description
  serialize :tags, coder: YAML

  scope :is_past, -> { where("end_time < ?", Date.current).order(start_time: :desc) }
  scope :is_current, -> { where("end_time >= ?", Date.current).order(:start_time) }
  scope :is_workshop, -> { where("lower(event_type) LIKE :w OR lower(tags) LIKE :w OR lower(libcal_categories) LIKE :w", w: "%workshop%") }
  scope :is_not_workshop, -> { where.not(id: is_workshop) }
  scope :is_dss_event, -> { where("lower(tags) LIKE ? OR lower(libcal_categories) LIKE ?", "%digital scholarship%", "%digital scholarship%") }
  scope :is_hsl_event, -> { where("lower(tags) LIKE ? OR lower(libcal_categories) LIKE ?", "%health sciences%", "%health sciences%") }
  scope :is_displayable, -> { where("suppress = ?", false) }

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
    internal_building ? internal_building.name : self[:location_name]
  end

  def location_name
    building_name
  end

  def building_address1
    internal_building ? internal_building.address1 : self[:address]
  end

  def building_address2
    internal_building ? internal_building.address2 : [self[:city], self[:state], self[:zip]].filter_map(&:presence).join(", ").presence
  end

  def location_address_lines
    [building_address1, building_address2].filter_map(&:presence)
  end

  def google_maps_query
    [location_name, self[:address], self[:city], self[:state], self[:zip]]
      .filter_map(&:presence)
      .join(", ")
      .presence
  end

  def location_space
    space ? space.name : self[:location_space]
  end

  def contact_name
    person ? "#{person.first_name} #{person.last_name}" : self[:contact_name]
  end

  def contact_email
    person ? person.email_address : self[:contact_email]
  end

  def contact_phone
    person ? person.phone_number : self[:contact_phone]
  end

  def has_internal_building?
    internal_building.present?
  end

  def internal_building
    building
  end
  def get_date
    display_time = start_time || end_time
    display_time&.strftime("%^a, %^b %d, %Y ")&.titleize
  end

  def set_start_time
    return "(All day)" if all_day
    return "" if start_time.nil?

    start_time.strftime("%l:%M %P")
  end

  def set_end_time
    return "" if all_day || end_time.nil? || end_time == start_time

    end_time.strftime("%l:%M %P")
  end

  def set_times
    return "(All day)" if all_day
    return "" if start_time.nil?
    return "#{start_time.strftime("%l:%M %P")} - #{end_time.strftime("%l:%M %P")}" if end_time.present? && end_time != start_time

    start_time.strftime("%l:%M %P")
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

  def self.search(q)
    if q
      Event.where("lower(title) LIKE ? or lower(tags) LIKE ?", "%#{q}%".downcase, "%#{q}%".downcase).order(:start_time)
    end
  end
end
