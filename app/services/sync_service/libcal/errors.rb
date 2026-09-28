# frozen_string_literal: true

module SyncService::Libcal::Errors
  MissingEventsSourceException = Class.new(StandardError)
  UnexpectedResponseShapeException = Class.new(StandardError)
  MissingAccessTokenConfigurationException = Class.new(StandardError)
  MissingEventIdException = Class.new(StandardError)
  ImageDownloadException = Class.new(StandardError)
end
