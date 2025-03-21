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

  has_rich_text :description
  serialize :tags

  scope :is_past, -> { where("end_time < ?", Date.current).order(start_time: :desc) }
  scope :is_current, -> { where("end_time >= ?", Date.current).order(:start_time) }
  scope :is_type_workshop, -> { where("lower(event_type) LIKE ?", "%workshop%") }
  scope :is_tagged_workshop, -> { where("lower(tags) LIKE ?", "%workshop%") }
  scope :is_workshop, -> { is_type_workshop.or(is_tagged_workshop) }
  scope :is_not_type_workshop, -> { where.not("lower(event_type) LIKE ?", "%workshop%") }
  scope :is_not_tagged_workshop, -> { where.not("lower(tags) LIKE ?", "%workshop%").or(where(tags: nil)) }
  scope :is_not_workshop, -> { is_not_type_workshop.and(is_not_tagged_workshop) }
  scope :is_dss_event, -> { where("lower(tags) LIKE ?", "%digital scholarship%") }
  scope :is_hsl_event, -> { where("lower(tags) LIKE ?", "%health sciences%") }
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
    case start_time
    when all_day
      "(All day)"
    when nil
      ""
    else
      start_time.strftime("%l:%M %P")
    end
  end

  def set_end_time
    case end_time
    when all_day
      "(All day)"
    when nil
      ""
    else
      end_time.strftime("%l:%M %P")
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

  def self.search(q)
    if q
      Event.where("lower(title) LIKE ? or lower(tags) LIKE ?", "%#{q}%".downcase, "%#{q}%".downcase).order(:start_time)
    end
  end
end
