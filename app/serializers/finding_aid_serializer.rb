# frozen_string_literal: true

class FindingAidSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :subject, :content_link, :identifier, :drupal_id
end
