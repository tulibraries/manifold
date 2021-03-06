# frozen_string_literal: true

module Admin::ApplicationHelper
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
    locals.merge!(field: field)
    render locals: locals, partial: field.to_partial_path
  end

  def fieldname_in_draft(resource, field)
    resource.class.to_s.downcase + "_" + field.attribute.to_s
  end

  def render_draft_field(field, locals = {})
    locals.merge!(field: field)
    render locals: locals, partial: "#{field.to_partial_path}_draft"
  end

  def draft_name(field)
    "draft_" + field.attribute.to_s
  end

  def is_draftable?(attributes)
    attributes.each do |attribute|
      draft_field_name = "draft_" + attribute.name
      return true if attribute.resource.respond_to?(draft_field_name)
    end
    return false
  end
end
