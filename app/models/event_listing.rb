# frozen_string_literal: true

class EventListing < ApplicationRecord
  self.table_name = "events"
  self.primary_key = :listing_id

  paginates_per 12

  attr_writer :source

  scope :current, -> { where("event_listings.end_date >= ?", Date.current) }
  scope :past, -> { where("event_listings.end_date < ?", Date.current) }
  scope :on_date, ->(date) { where("event_listings.start_date <= ? AND event_listings.end_date >= ?", date, date) }
  scope :matching, ->(query) { where("lower(event_listings.title) LIKE :query OR lower(event_listings.search_terms) LIKE :query", query: "%#{query.to_s.downcase}%") }
  scope :exhibitions_first, -> { order(Arel.sql("CASE event_listings.source_type WHEN 'exhibition' THEN 0 ELSE 1 END"), Arel.sql("event_listings.start_date"), Arel.sql("event_listings.source_id")) }
  scope :most_recent_first, -> { order(Arel.sql("event_listings.end_date DESC"), Arel.sql("event_listings.start_date DESC"), Arel.sql("event_listings.source_type ASC"), Arel.sql("event_listings.source_id ASC")) }

  def self.feed
    unscoped.from(Arel.sql("(#{union_sql}) event_listings")).select("event_listings.*")
  end

  def source
    @source ||= source_class.find(source_id)
  end

  def event?
    source_type == "event"
  end

  def exhibition?
    source_type == "exhibition"
  end

  private

    def self.union_sql
      <<~SQL.squish
        SELECT
          'event-' || events.id::text AS listing_id,
          events.id AS source_id,
          'event' AS source_type,
          events.title,
          events.start_time::date AS start_date,
          events.end_time::date AS end_date,
          events.tags AS search_terms
        FROM events
        WHERE events.suppress = FALSE

        UNION ALL

        SELECT
          'exhibition-' || exhibitions.id::text AS listing_id,
          exhibitions.id AS source_id,
          'exhibition' AS source_type,
          exhibitions.title,
          exhibitions.start_date,
          exhibitions.end_date,
          NULL::text AS search_terms
        FROM exhibitions
        WHERE exhibitions.promoted_to_events = TRUE
      SQL
    end

    def source_class
      event? ? Event : Exhibition
    end
end
