# frozen_string_literal: true

require "rails_helper"

RSpec.describe Form, type: :model do
  describe "#mail_form_attributes" do
    it "preserves the legacy notification attribute ordering" do
      keys = described_class.new.mail_form_attributes.keys

      av_fields = Form::RequestDefinition.slots.flat_map do |slot|
        Form::RequestDefinition.attribute_fields("av-requests").map do |field|
          Form::RequestDefinition.field_key(field, slot)
        end
      end

      copy_only_fields =
        Form::RequestDefinition.attribute_fields("copy-requests") -
        Form::RequestDefinition.attribute_fields("av-requests")

      copy_fields = Form::RequestDefinition.slots.flat_map do |slot|
        copy_only_fields.map do |field|
          Form::RequestDefinition.field_key(field, slot)
        end
      end

      expect(keys.slice(keys.index("request_title"), av_fields.length))
        .to eq(av_fields)

      expect(keys.slice(keys.index("box"), copy_fields.length))
        .to eq(copy_fields)

      expect(keys.index("recipients")).to be < keys.index("request_title")
      expect(keys.index("format_09")).to be < keys.index("tu_id")
      expect(keys.index("id_acknowledgment")).to be < keys.index("box")
    end
  end
end
