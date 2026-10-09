# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::FormSubmissions::RequestDetailsComponent, type: :component do
  describe "AV request rendering" do
    it "renders populated requests with consecutive numbering" do
      form_submission = instance_double(
        FormSubmission,
        form_type: "av-requests",
      )

      attributes = {
        "collection_title" => "First Collection",
        "identifier" => "AV-001",
        "format" => "film",
        "collection_title_02" => "Third Collection",
        "identifier_02" => "AV-003",
        "format_02" => "audio",
      }

      component = described_class.new(
        form_submission: form_submission,
        attributes: attributes,
      )

      html = component.render_in(
        ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil),
      )

      document = Nokogiri::HTML.fragment(html)

      expect(document.css(".request-number").map(&:text)).to eq(
        ["Request 1", "Request 2"],
      )
      expect(document.text).to include("First Collection", "Third Collection")
      expect(document.text).to include("Film: $30 per minute")
      expect(document.text).to include("Audio: $50 per tape/reel")
      expect(document.text).not_to include("Request 3")
    end
  end

  describe "Copy request rendering" do
    it "renders Copy-specific fields and format labels" do
      form_submission = instance_double(
        FormSubmission,
        form_type: "copy-requests",
      )

      attributes = {
        "collection_title" => "Special Collections",
        "box" => "Box 3",
        "folder" => "Folder 7",
        "identifier" => "Document 42",
        "estimated_pages" => "12",
        "format" => "pdf",
      }

      component = described_class.new(
        form_submission: form_submission,
        attributes: attributes,
      )

      html = component.render_in(
        ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil),
      )

      document = Nokogiri::HTML.fragment(html)

      expect(document.css(".request-number").map(&:text)).to eq(["Request 1"])
      expect(document.text).to include(
        "Special Collections",
        "Box 3",
        "Folder 7",
        "Document 42",
        "12",
        "PDF: $0.50 per page",
      )
      expect(document.text).to include("Estimated Pages")
      expect(document.text).not_to include("Notes")
    end
  end

  describe "partially populated requests" do
    it "renders a request when only one field is populated" do
      form_submission = instance_double(
        FormSubmission,
        form_type: "av-requests",
      )

      component = described_class.new(
        form_submission: form_submission,
        attributes: { "notes_03" => "Digitization requested" },
      )

      html = component.render_in(
        ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil),
      )

      document = Nokogiri::HTML.fragment(html)

      expect(document.css(".request-number").map(&:text)).to eq(["Request 1"])
      expect(document.text).to include("Digitization requested")
      expect(document.text).to include("Not provided")
      expect(document.css(".no-requests")).to be_empty
    end
  end

  describe "empty requests" do
    it "displays the empty-state message when no request fields are populated" do
      form_submission = instance_double(
        FormSubmission,
        form_type: "av-requests",
      )

      component = described_class.new(
        form_submission: form_submission,
        attributes: {
          "name" => "Test User",
          "email" => "test@example.com",
        },
      )

      html = component.render_in(
        ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil),
      )

      document = Nokogiri::HTML.fragment(html)

      expect(document.css(".request-item")).to be_empty
      expect(document.css(".no-requests").text.strip).to eq(
        "No requests specified.",
      )
    end
  end
end
