# frozen_string_literal: true

require "net/http"
require "socket"
require "tempfile"
require "digest"

class SyncService::Libcal::ImageAttacher
  include SyncService::Libcal::Errors

  class Ipv4ConnectionAdapter < HTTParty::ConnectionAdapter
    def connection
      http = super
      ipv4 = Addrinfo.getaddrinfo(uri.host, nil, Socket::AF_INET, :STREAM).first&.ip_address
      raise SyncService::Libcal::Errors::ImageDownloadException, "No IPv4 address for #{uri.host}" if ipv4.blank?

      http.ipaddr = ipv4
      http
    end
  end

  attr_reader :failures

  def initialize(error_reporter:)
    @error_reporter = error_reporter
    @failures = []
  end

  def attach(record, event)
    if record["image_url"].present?
      attach_image(record, event)
    else
      event.image.purge_later
    end
    event.alt_text = record["image_alt_text"]
  end

  private

    def attach_image(record, event)
      image_to_attach = remote_image(record["image_url"], record["image_alt_text"], event)
      return false if image_to_attach.blank?

      io = image_to_attach[:image][:io]
      if io.size >= image_size_limit_bytes
        message = "LibCal image for #{event.title.inspect} is #{io.size} bytes, over the #{image_size_limit_bytes}-byte limit; saving event without image"
        report_failure(ImageDownloadException.new(message), message, event, record["image_url"])
        return false
      end

      return false if image_unchanged?(event, io)

      event.image.attach(
        io:,
        filename: image_to_attach[:image][:filename],
        metadata: { alt_text: image_to_attach[:metadata][:alt_text] }
      )
      true
    end

    def image_unchanged?(event, io)
      return false unless event.image.attached?

      checksum = Digest::MD5.base64digest(io.read)
      io.rewind
      checksum == event.image.blob.checksum
    end

    def image_size_limit_bytes
      I18n.t("manifold.default.image_file_size_limit").kilobyte
    end

    def remote_image(image_url, alt_text, event)
      image_file = download_image_over_ipv4(image_url, event)

      {
        image: {
          io: image_file,
          filename: File.basename(URI.parse(image_url).path).presence || "#{event.guid}.jpg"
        },
        metadata: { alt_text: alt_text.to_s }
      }
    rescue StandardError => e
      report_failure(e, "LibCal image retrieval failure: #{e.message}", event, image_url)
      {}
    end

    def report_failure(err, message, event, image_url)
      @failures << event
      @error_reporter.report(err,
        message:,
        context: { libcal_event_id: event.guid, libcal_event_title: event.title, image_url: image_url.to_s })
    end

    def download_image_over_ipv4(image_url, event)
      unless image_url.to_s.match?(%r{\Ahttps?://}i)
        raise ImageDownloadException, "Refusing to download non-HTTP image URL: #{image_url}"
      end

      response = HTTParty.get(
        image_url,
        connection_adapter: Ipv4ConnectionAdapter,
        follow_redirects: true,
        open_timeout: 10,
        read_timeout: 30
      )

      unless response.success?
        raise ImageDownloadException, "Image request for #{image_url} returned #{response.code}"
      end

      file = Tempfile.new(["libcal-event-image-#{event.guid}-", File.extname(URI.parse(image_url).path)])
      file.binmode
      file.write(response.body)
      file.rewind
      file
    end
end
