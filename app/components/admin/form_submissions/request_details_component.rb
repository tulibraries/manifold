# frozen_string_literal: true

class Admin::FormSubmissions::RequestDetailsComponent < ViewComponent::Base
  def initialize(form_submission:, attributes:)
    @form_submission = form_submission
    @attributes = attributes
  end

  def av_request?
    @form_submission.form_type == "av-requests"
  end

  def requests
    @requests ||= Form::RequestDefinition.slots.filter_map do |slot|
      fields = Form::RequestDefinition.request_fields(@form_submission.form_type)

      values = fields.to_h do |field|
        key = Form::RequestDefinition.field_key(field, slot)
        [field.to_s, @attributes[key]]
      end

      values if values.values.any?(&:present?)
    end
  end

  def format_label(value)
    return "Not provided" if value.blank?

    Form::RequestDefinition.format_label(
      @form_submission.form_type,
      value,
      surface: :admin,
    )
  end
end
