# frozen_string_literal: true

module SchemaDotOrgable
  extend ActiveSupport::Concern


  def base_attributes
    {
      "@context" => "https://schema.org",
      "@type" => "#{schema_dot_org_type}",
      name: label,
      description: (description.body.presence&.to_html),
      image: (index_image_url if (respond_to?(:index_image_url) && image&.attached?)),
    }.compact
  end

  def additional_schema_dot_org_attributes
    {}
  end

  def merge_base_and_additional_attributes
    base_attributes.merge(additional_schema_dot_org_attributes).compact.with_indifferent_access
  end

  def map_to_schema_dot_org
    begin
      merge_base_and_additional_attributes
    rescue => exception
      Honeybadger.notify(exception)
      {}
    end
  end
end
