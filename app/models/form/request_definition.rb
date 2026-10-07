# frozen_string_literal: true

class Form::RequestDefinition
  SLOT_COUNT = 10

  DEFINITIONS = {
    "av-requests" => {
      i18n_key: "manifold.forms.request_definitions.av_requests",

      request_fields: %i[
        collection_title
        identifier
        notes
        format
      ],

      count_fields: %i[
        collection_title
        identifier
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
          csv: "Collection Title",
          excel: "Collection",
        },
        identifier: {
          csv: "Identifier/File Name/Description",
          excel: "Identifier",
        },
        notes: {
          csv: "Notes",
          excel: "Notes",
        },
        format: {
          csv: "Format",
          excel: "Format",
        },
      },

      format_labels: {
        "film" => {
          csv: "Film: $30 per minute",
          excel: "Film",
        },
        "video" => {
          csv: "Video: $50 per tape",
          excel: "Video",
        },
        "audio" => {
          csv: "Audio: $50 per tape/reel",
          excel: "Audio",
        },
      },
    },

    "copy-requests" => {
      i18n_key: "manifold.forms.request_definitions.copy_requests",

      request_fields: %i[
        collection_title
        box
        folder
        identifier
        estimated_pages
        format
      ],

      count_fields: %i[
        collection_title
        box
        folder
        identifier
        format
      ],

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

      acknowledgements: %i[
        duplication_limits
        copyright_acknowledgment
      ],

      field_labels: {
        collection_title: {
          csv: "Collection Title",
          excel: "Collection",
        },
        box: {
          csv: "Box",
          excel: "Box",
        },
        folder: {
          csv: "Folder",
          excel: "Folder",
        },
        identifier: {
          csv: "Title/Identifier/File Name/Description",
          excel: "Identifier",
        },
        estimated_pages: {
          csv: "Estimated Number of Pages",
          excel: "Estimated Pages",
        },
        format: {
          csv: "Format",
          excel: "Format",
        },
      },

      format_labels: {
        "tiff" => {
          csv: "TIFF (600 DPI): $5 per image",
          excel: "TIFF (600 DPI): $5 per image",
        },
        "pdf" => {
          csv: "PDF: $0.50 per page",
          excel: "PDF: $0.50 per page",
        },
        "photocopy" => {
          csv: "Photocopy: $0.50 per page plus postage",
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

    def count_fields(form_type)
      definition_for(form_type).fetch(:count_fields)
    end

    def attribute_fields(form_type)
      definition_for(form_type).fetch(:attribute_fields)
    end

    def acknowledgements(form_type)
      definition_for(form_type).fetch(:acknowledgements)
    end

    def i18n_key(form_type)
      definition_for(form_type).fetch(:i18n_key)
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

      return labels.fetch(surface) if %i[csv excel].include?(surface)

      key =
        if surface == :admin && field == :estimated_pages
          :estimated_pages_admin
        else
          field
        end

      I18n.t("#{i18n_key(form_type)}.fields.#{key}")
    end

    def format_label(form_type, value, surface: :default)
      labels = definition_for(form_type).fetch(:format_labels).fetch(value.to_s, nil)
      return value if labels.nil?

      return labels.fetch(surface) if %i[csv excel].include?(surface)

      key =
        if surface == :form && form_type == "copy-requests" && value.to_s == "photocopy"
          :photocopy_form
        else
          value
        end

      I18n.t("#{i18n_key(form_type)}.formats.#{key}")
    end

    def attribute_fields_for_all_request_types
      DEFINITIONS
        .values
        .flat_map { |definition| definition.fetch(:attribute_fields) }
        .uniq
    end

    def display_name(form_type)
      I18n.t("#{i18n_key(form_type)}.display_name")
    end

    def collection_title(form_type)
      I18n.t("#{i18n_key(form_type)}.collection_title")
    end

    def detail_title(form_type)
      I18n.t("#{i18n_key(form_type)}.detail_title")
    end
  end
end
