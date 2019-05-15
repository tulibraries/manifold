# frozen_string_literal: true

class PersonSerializer < ApplicationSerializer
  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |person| helpers.url_for(person) }

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties
  attribute :image, if: Proc.new { |person| person.image.attached? } do |person|
    helpers.rails_blob_url(person.image)
  end

  attribute :thumbnail_image, if: Proc.new { |person| person.image.attached? } do |person|
    helpers.rails_representation_url(person.image.variant(resize: "100x100").processed)
  end

  has_many :groups
  has_many :spaces
end
