# frozen_string_literal: true

require "rails_helper"

RSpec.describe Form::RequestDefinition do
  describe ".request_fields" do
    it "returns the AV request fields in existing order" do
      expect(described_class.request_fields("av-requests")).to eq(
        %i[collection_title identifier notes format],
      )
    end

    it "returns the Copy request fields in existing order" do
      expect(described_class.request_fields("copy-requests")).to eq(
        %i[collection_title box folder identifier estimated_pages format],
      )
    end
  end

  describe ".count_fields" do
    it "preserves the AV fields required for collection request counting" do
      expect(described_class.count_fields("av-requests")).to eq(
        %i[collection_title identifier format],
      )
    end

    it "preserves the Copy fields required for collection request counting" do
      expect(described_class.count_fields("copy-requests")).to eq(
        %i[collection_title box folder identifier format],
      )
    end
  end

  describe ".attribute_fields" do
    it "preserves AV request attributes including request_title" do
      expect(described_class.attribute_fields("av-requests")).to eq(
        %i[
          request_title
          collection_title
          identifier
          notes
          format
        ],
      )
    end

    it "preserves Copy request attributes" do
      expect(described_class.attribute_fields("copy-requests")).to eq(
        %i[
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
      )
    end
  end

  describe ".acknowledgements" do
    it "includes the AV-only outside vendor fees acknowledgement" do
      expect(described_class.acknowledgements("av-requests")).to eq(
        %i[outside_vendor_fees duplication_limits copyright_acknowledgment],
      )
    end

    it "does not include outside vendor fees for Copy requests" do
      expect(described_class.acknowledgements("copy-requests")).to eq(
        %i[duplication_limits copyright_acknowledgment],
      )
    end
  end

  describe ".slots" do
    it "defines ten request slots" do
      expect(described_class.slots.to_a).to eq((0..9).to_a)
    end
  end

  describe ".field_key" do
    it "uses an unsuffixed key for the first request" do
      expect(described_class.field_key(:collection_title, 0)).to eq(
        "collection_title",
      )
    end

    it "uses zero-padded suffixes for additional requests" do
      expect(described_class.field_key(:collection_title, 1)).to eq(
        "collection_title_01",
      )

      expect(described_class.field_key(:collection_title, 9)).to eq(
        "collection_title_09",
      )
    end
  end

  describe ".field_label" do
    it "preserves default and Excel labels for collection title" do
      expect(
        described_class.field_label("av-requests", :collection_title),
      ).to eq("Collection Title")

      expect(
        described_class.field_label(
          "av-requests",
          :collection_title,
          surface: :excel,
        ),
      ).to eq("Collection")
    end

    it "preserves the Copy identifier label difference" do
      expect(
        described_class.field_label("copy-requests", :identifier),
      ).to eq("Title/Identifier/File Name/Description")

      expect(
        described_class.field_label(
          "copy-requests",
          :identifier,
          surface: :excel,
        ),
      ).to eq("Identifier")
    end

    it "preserves the Copy estimated pages admin label" do
      expect(
        described_class.field_label("copy-requests", :estimated_pages),
      ).to eq("Estimated Number of Pages")

      expect(
        described_class.field_label(
          "copy-requests",
          :estimated_pages,
          surface: :admin,
        ),
      ).to eq("Estimated Pages")
    end

    it "preserves CSV field labels independently of localization" do
      expect(
        described_class.field_label(
          "av-requests",
          :collection_title,
          surface: :csv,
        ),
      ).to eq("Collection Title")

      expect(
        described_class.field_label(
          "copy-requests",
          :estimated_pages,
          surface: :csv,
        ),
      ).to eq("Estimated Number of Pages")
    end
  end

  describe ".format_label" do
    it "preserves AV pricing labels by default" do
      expect(
        described_class.format_label("av-requests", "film"),
      ).to eq("Film: $30 per minute")
    end

    it "preserves the shorter AV Excel label" do
      expect(
        described_class.format_label(
          "av-requests",
          "film",
          surface: :excel,
        ),
      ).to eq("Film")
    end

    it "preserves Copy pricing labels in Excel" do
      expect(
        described_class.format_label(
          "copy-requests",
          "pdf",
          surface: :excel,
        ),
      ).to eq("PDF: $0.50 per page")
    end

    it "returns an unknown format value unchanged" do
      expect(
        described_class.format_label("av-requests", "unknown"),
      ).to eq("unknown")
    end

    it "preserves the longer Copy form label for photocopy" do
      expect(
        described_class.format_label(
          "copy-requests",
          "photocopy",
          surface: :form,
        ),
      ).to eq(
        "Photocopy: $0.50 per page plus postage (Up to 100 pages: $5.00; Over 100 pages, USPS rate)",
      )
    end

    it "preserves CSV format labels independently of localization" do
      expect(
        described_class.format_label(
          "av-requests",
          "film",
          surface: :csv,
        ),
      ).to eq("Film: $30 per minute")

      expect(
        described_class.format_label(
          "copy-requests",
          "photocopy",
          surface: :csv,
        ),
      ).to eq("Photocopy: $0.50 per page plus postage")
    end
  end

  describe ".attribute_fields_for_all_request_types" do
    it "combines shared request attributes without duplication" do
      expect(described_class.attribute_fields_for_all_request_types).to eq(
        %i[
          request_title
          collection_title
          identifier
          notes
          format
          box
          folder
          estimated_pages
          pricing_tiff
          pricing_pdf
          pricing_photocopy
        ],
      )
    end
  end

  describe ".display_name" do
    it "returns the display name for each request type" do
      expect(described_class.display_name("av-requests")).to eq("AV Request")
      expect(described_class.display_name("copy-requests")).to eq("Copy Request")
    end
  end

  describe ".collection_title" do
    it "returns the collection title for each request type" do
      expect(described_class.collection_title("av-requests")).to eq("AV Request Submissions")
      expect(described_class.collection_title("copy-requests")).to eq("Copy Request Submissions")
    end
  end

  describe ".detail_title" do
    it "returns the detail title for each request type" do
      expect(described_class.detail_title("av-requests")).to eq("AV Request Details")
      expect(described_class.detail_title("copy-requests")).to eq("Copy Request Details")
    end
  end
end
