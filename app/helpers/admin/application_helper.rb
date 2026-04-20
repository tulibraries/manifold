# frozen_string_literal: true

module Admin::ApplicationHelper
  include Administrate::ApplicationHelper

  def changed_fields(changed)
    exclude_keys = ["id", "created_at", "updated_at"]
    changed.delete_if { |k, v| exclude_keys.include?(k) }
    changed.delete_if { |k, v| v.first.nil? }
    changed_map = changed.map do |f|
      "<h2>#{f.first}</h2>" +
        Diffy::Diff.new(f.last.first, f.last.last, include_plus_and_minus_in_html: true).to_s(:html)
    end
    changed_map.join("<br/>").html_safe
  end

  def render_show_field(field, locals = {})
    locals.merge!(field:)
    if (prefix = find_partial_prefix(field))
      render locals:, partial: "#{prefix}/#{field.page}"
    end
  end

  def fieldname_in_draft(resource, field)
    resource.class.to_s.downcase + "_" + field.attribute.to_s
  end

  def render_draft_field(field, locals = {})
    locals.merge!(field:)
    locals.merge!(draft_field: locals[:f].object.send(draft_name(field)))
    if (prefix = find_partial_prefix(field))
      render locals:, partial: "#{prefix}/#{field.page}_draft"
    end
  end

  def draft_name(field)
    "draft_" + field.attribute.to_s
  end

  def is_draftable?(attributes)
    attributes.each do |title, attributes|
      attributes.each do |attribute|
        return true if attribute.resource.respond_to?("draft_" + attribute.name)
      end
      return false
    end
  end

  def phone_formatted(phone_number = "")
    digits = phone_number.to_s.gsub(/\D/, "")
    if digits.size == 10
      number_to_phone(digits, area_code: true)
    else
      phone_number
    end
  end
end
