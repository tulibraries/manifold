# frozen_string_literal: true

class Form::RequestDefinition
  SLOT_COUNT = 10

  DEFINITIONS = {
    "av-requests" => {
      request_fields: %i[
        collection_title
        identifier
        notes
        format
      ],

      attribute_fields: %i[
        request_title
        collection_title
        identifier
        notes
        format
      ],

      acknowledgements: %i[
        outside_vendor_fees
        duplication_limits
        copyright_acknowledgment
      ],

      field_labels: {
        collection_title: {
          default: "Collection Title",
          excel: "Collection",
        },
        identifier: {
          default: "Identifier/File Name/Description",
          excel: "Identifier",
        },
        notes: {
          default: "Notes",
          excel: "Notes",
        },
        format: {
          default: "Format",
          excel: "Format",
        },
      },

      format_labels: {
        "film" => {
          default: "Film: $30 per minute",
          excel: "Film",
        },
        "video" => {
          default: "Video: $50 per tape",
          excel: "Video",
        },
        "audio" => {
          default: "Audio: $50 per tape/reel",
          excel: "Audio",
        },
      },
    },

    "copy-requests" => {
      attribute_fields: %i[
        collection_title
        box
        folder
        identifier
        estimated_pages
        format
        pricing_tiff
        pricing_pdf
        pricing_photocopy
      ],

      request_fields: %i[
        collection_title
        box
        folder
        identifier
        estimated_pages
        format
      ],

      acknowledgements: %i[
        duplication_limits
        copyright_acknowledgment
      ],

      field_labels: {
        collection_title: {
          default: "Collection Title",
          excel: "Collection",
        },
        box: {
          default: "Box",
          excel: "Box",
        },
        folder: {
          default: "Folder",
          excel: "Folder",
        },
        identifier: {
          default: "Title/Identifier/File Name/Description",
          excel: "Identifier",
        },
        estimated_pages: {
          default: "Estimated Number of Pages",
          admin: "Estimated Pages",
          excel: "Estimated Pages",
        },
        format: {
          default: "Format",
          excel: "Format",
        },
      },

      format_labels: {
        "tiff" => {
          default: "TIFF (600 DPI): $5 per image",
          excel: "TIFF (600 DPI): $5 per image",
        },
        "pdf" => {
          default: "PDF: $0.50 per page",
          excel: "PDF: $0.50 per page",
        },
        "photocopy" => {
          default: "Photocopy: $0.50 per page plus postage",
          excel: "Photocopy: $0.50 per page plus postage",
        },
      },
    },
  }.freeze

  class << self
    def definition_for(form_type)
      DEFINITIONS.fetch(form_type)
    end

    def request_fields(form_type)
      definition_for(form_type).fetch(:request_fields)
    end

    def attribute_fields(form_type)
      definition_for(form_type).fetch(:attribute_fields)
    end

    def acknowledgements(form_type)
      definition_for(form_type).fetch(:acknowledgements)
    end

    def slots
      0...SLOT_COUNT
    end

    def field_key(field, slot)
      return field.to_s if slot.zero?

      "#{field}_#{slot.to_s.rjust(2, '0')}"
    end

    def field_label(form_type, field, surface: :default)
      labels = definition_for(form_type).fetch(:field_labels).fetch(field)
      labels[surface] || labels.fetch(:default)
    end

    def format_label(form_type, value, surface: :default)
      labels = definition_for(form_type).fetch(:format_labels).fetch(value.to_s, nil)
      return value if labels.nil?

      labels[surface] || labels.fetch(:default)
    end

    def attribute_fields_for_all_request_types
      DEFINITIONS
        .values
        .flat_map { |definition| definition.fetch(:attribute_fields) }
        .uniq
    end
  end
end
