# frozen_string_literal: true

class PersonSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |person| helpers.url_for(person) }

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties
  attribute :photo, if: Proc.new { |person| person.photo.attached? } do |person|
    helpers.rails_blob_url(person.photo)
  end

  attribute :thumbnail_photo, if: Proc.new { |person| person.photo.attached? } do |person|
    helpers.rails_representation_url(person.photo.variant(resize: "100x100").processed)
  end

  has_many :groups
  has_many :spaces
end
