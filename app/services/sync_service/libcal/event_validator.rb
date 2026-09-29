# frozen_string_literal: true

class SyncService::Libcal::EventValidator
  include SyncService::Libcal::Errors

  def guid!(raw_event)
    raw_event["id"].presence&.to_s ||
      raise(MissingEventIdException, "No LibCal event id found for #{raw_event}")
  end
end
