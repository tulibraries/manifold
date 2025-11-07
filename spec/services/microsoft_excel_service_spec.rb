# frozen_string_literal: true

require "rails_helper"

RSpec.describe MicrosoftExcelService do
  subject(:service) { described_class.allocate }

  describe "#format_form_data" do
    let(:timestamp) { Time.zone.local(2024, 1, 1, 12, 0, 0) }

    before { allow(Time).to receive(:current).and_return(timestamp) }

    it "formats AV requests with additional requests" do
      form_data = {
        "name" => "Primary User",
        "email" => "av@example.com",
        "phone" => "555-0000",
        "affiliation" => "temple",
        "address" => "123 Library Ln",
        "collection_title" => "Main Collection",
        "identifier" => "Box 1",
        "notes" => "Handle with care",
        "format" => "film",
        "collection_title_01" => "Second Collection",
        "identifier_01" => "Box 2",
        "notes_01" => "Notes for request 2",
        "format_01" => "audio",
        "outside_vendor_fees" => "1",
        "duplication_limits" => "true",
        "copyright_acknowledgment" => "false",
      }

      row = service.send(:format_form_data, form_data, "AV-Requests")

      expect(row).to eq(
        [
          "Primary User",
          "av@example.com",
          "555-0000",
          "Temple University Affiliates",
          "123 Library Ln",
          "Request 1: Collection: Main Collection | Identifier: Box 1 | Notes: Handle with care | Format: Film\nRequest 2: Collection: Second Collection | Identifier: Box 2 | Notes: Notes for request 2 | Format: Audio",
          "Yes",
          "Yes",
          "No",
          "2024-01-01 12:00:00",
        ],
      )
    end

    it "formats Copy requests with additional requests" do
      form_data = {
        "name" => "Copy User",
        "email" => "copy@example.com",
        "phone" => "555-1111",
        "affiliation" => "non-temple",
        "address" => "456 Archive Rd",
        "collection_title" => "Copy Collection",
        "box" => "Box A",
        "folder" => "Folder 1",
        "identifier" => "Item 123",
        "estimated_pages" => "25",
        "format" => "pdf",
        "collection_title_01" => "Extra Collection",
        "box_01" => "Box B",
        "folder_01" => "Folder 2",
        "identifier_01" => "Item 456",
        "estimated_pages_01" => "50",
        "format_01" => "photocopy",
        "duplication_limits" => true,
        "copyright_acknowledgment" => false,
      }

      row = service.send(:format_form_data, form_data, "Copy-Requests")

      expect(row).to eq(
        [
          "Copy User",
          "copy@example.com",
          "555-1111",
          "Non-Temple Affiliates",
          "456 Archive Rd",
          "Request 1: Collection: Copy Collection | Box: Box A | Folder: Folder 1 | Identifier: Item 123 | Estimated Pages: 25 | Format: PDF: $0.50 per page\nRequest 2: Collection: Extra Collection | Box: Box B | Folder: Folder 2 | Identifier: Item 456 | Estimated Pages: 50 | Format: Photocopy: $0.50 per page plus postage",
          "Yes",
          "No",
          "2024-01-01 12:00:00",
        ],
      )
    end
  end

  describe "#build_range_address" do
    it "returns the correct range for the given row and column count" do
      expect(service.send(:build_range_address, 5, 3)).to eq("A5:C5")
    end
  end

  describe "#workbook_item_path" do
    it "prefers drive_id when present" do
      client = MicrosoftGraph::Client.allocate
      client.instance_variable_set(:@drive_id, "drive123")
      client.instance_variable_set(:@site_id, nil)
      client.instance_variable_set(:@site_hostname, nil)
      client.instance_variable_set(:@site_path, nil)

      expect(client.send(:workbook_item_path, "file456")).to eq("/drives/drive123/items/file456")
    end

    it "falls back to site_id" do
      client = MicrosoftGraph::Client.allocate
      client.instance_variable_set(:@drive_id, nil)
      client.instance_variable_set(:@site_id, "site789")
      client.instance_variable_set(:@site_hostname, nil)
      client.instance_variable_set(:@site_path, nil)

      expect(client.send(:workbook_item_path, "file456")).to eq("/sites/site789/drive/items/file456")
    end

    it "builds path from hostname and site path" do
      client = MicrosoftGraph::Client.allocate
      client.instance_variable_set(:@drive_id, nil)
      client.instance_variable_set(:@site_id, nil)
      client.instance_variable_set(:@site_hostname, "contoso.sharepoint.com")
      client.instance_variable_set(:@site_path, "sites/LibraryTeam")

      expect(client.send(:workbook_item_path, "file456")).to eq("/sites/contoso.sharepoint.com:/sites/LibraryTeam:/drive/items/file456")
    end
  end
end
