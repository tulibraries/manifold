# frozen_string_literal: true

class FindingAidSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :name, :subject, :content_link, :identifier, :drupal_id
end
