class FindingAidSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :subject, :content_link, :identifier, :drupal_id, :label
end
