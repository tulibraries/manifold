# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exhibition, type: :model do
  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      start_date: [Date.parse("2018/9/24"), DateTime.parse("2018/9/1")],
      end_date: [Date.parse("2018/10/24"), DateTime.parse("2018/10/10")],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        next if k == :description # Description not versionable
        exhibition = FactoryBot.create(:exhibition, k => v.first)
        exhibition.update(k => v.last)
        exhibition.save!
        expect(exhibition.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "#additional_schema_dot_org_attributes" do
    let(:building) { double(address1: "123 Main St", address2: "Suite 100") }
    let(:space) { double(label: "Conference Room A", building: building) }
    let(:start_date) { Date.new(2024, 1, 1) }
    let(:end_date) { Date.new(2024, 12, 31) }

    before do
      allow(subject).to receive(:start_date).and_return(start_date)
      allow(subject).to receive(:end_date).and_return(end_date)
    end

    context "when space is present" do

      before do
        allow(subject).to receive(:space).and_return(space)
      end

      it "returns the correct schema.org attributes" do
        expected_output = {
          startDate: start_date,
          endDate: end_date,
          location: {
            "@type" => "Place",
            name: space.label,
            address: {
              "@type" => "PostalAddress",
              streetAddress: building.address1,
              addressLocality: building.address2
            }
          }
      }

      expect(subject.additional_schema_dot_org_attributes).to eq(expected_output)
      end
    end

    context "when space is nil" do
      before do
        allow(subject).to receive(:space).and_return(nil)
      end

      it "returns nil for location" do
        expected_output = {
          startDate: start_date,
          endDate: end_date,
          location: nil
        }

        expect(subject.additional_schema_dot_org_attributes).to eq(expected_output)
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageables"

end
