# frozen_string_literal: true

class SyncService::Libcal::EventMapper
  include SyncService::Libcal::Errors

  def initialize(location_resolver: SyncService::Libcal::LocationResolver.new,
                 validator: SyncService::Libcal::EventValidator.new)
    @location_resolver = location_resolver
    @validator = validator
  end

  def map(raw_event)
    event = normalize(raw_event)

    {
      "guid" => guid(event),
      "title" => title(event),
      "description" => event.fetch("description", nil),
      "libcal_categories" => libcal_categories(event),
      "registration_link" => registration_link(event),
      "event_url" => event.fetch("online_join_url", nil),
      "start_time" => start_time(event),
      "end_time" => end_time(event),
      "all_day" => all_day(event),
      "location_name" => location_name(event),
      "image_url" => event.fetch("featured_image", nil),
      "image_alt_text" => event.fetch("featured_image_alt_text", nil)
    }.merge(contact(event))
     .merge(@location_resolver.resolve(location_name(event)))
  end

  def title(raw_event)
    value(raw_event, "title")
  end

  def start_time(raw_event)
    parse_time(value(raw_event, "start"))
  end

  private

    def normalize(raw_event)
      raw_event.to_h.deep_stringify_keys
    end

    def guid(raw_event)
      @validator.guid!(raw_event)
    end

    def libcal_categories(raw_event)
      names = category_names(raw_event)
      names.join(", ").presence
    end

    def registration_status(raw_event)
      ActiveModel::Type::Boolean.new.cast(value(raw_event, "registration")) || false
    end

    # LibCal has no separate registration URL; registration happens on the event page.
    def registration_link(raw_event)
      public_url(raw_event) if registration_status(raw_event)
    end

    def end_time(raw_event)
      parse_time(value(raw_event, "end"))
    end

    def all_day(raw_event)
      ActiveModel::Type::Boolean.new.cast(value(raw_event, "allday"))
    end

    def contact(raw_event)
      contact_name = presenter_name(raw_event)
      contact_person = FuzzyFind::Person.find(contact_name) if contact_name.present?
      contact_email = owner_email(raw_event) if presenter(raw_event).blank?

      {
        "person" => contact_person,
        "contact_name" => (contact_name unless contact_person),
        "contact_email" => (contact_email unless contact_person)
      }
    end

    def presenter_name(raw_event)
      presenter(raw_event) || extract_name(value(raw_event, "owner"))
    end

    def presenter(raw_event)
      value(raw_event, "presenter").to_s.strip.presence
    end

    def owner_email(raw_event)
      owner = value(raw_event, "owner")
      owner["email"].to_s.strip.presence if owner.is_a?(Hash)
    end

    def location_name(raw_event)
      extract_name(value(raw_event, "location"))
    end

    def public_url(raw_event)
      url_value(raw_event, "public")
    end

    def value(raw_event, key)
      raw_event[key]
    end

    def url_value(raw_event, key)
      return unless value(raw_event, "url").is_a?(Hash)

      value(raw_event, "url")[key]
    end

    def category_names(raw_event)
      Array.wrap(value(raw_event, "category"))
        .flatten
        .filter_map { |entry| extract_name(entry) }
        .uniq
    end

    def extract_name(entry)
      entry["name"].to_s.strip.presence if entry.is_a?(Hash)
    end

    def parse_time(value)
      return if value.blank?

      Time.zone.parse(value.to_s)
    end
end
