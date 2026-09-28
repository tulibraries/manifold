# frozen_string_literal: true

class SyncService::Libcal::EventPersister
  def initialize(image_attacher:)
    @image_attacher = image_attacher
  end

  def persist(record)
    event = Event.find_by(guid: record["guid"]) || Event.new

    event.assign_attributes(record.except("person", "building", "image_url", "image_alt_text", "event_url"))
    event.person = record["person"]
    event.building = record["building"]
    event.space = record["space"]
    event.location_name = record["location_name"]
    event.location_space = record["location_space"]
    event.address = record["address"]
    event.city = record["city"]
    event.state = record["state"]
    event.zip = record["zip"]
    event.libcal_categories = record["libcal_categories"]
    event.event_url = record["event_url"]
    event.event_type = ("Online" if record["event_url"].present?)

    @image_attacher.attach(record, event)

    event.save!
    PreprocessEventImageVariantsJob.perform_now(event) if event.image.attached?
    true
  end
end
