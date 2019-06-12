# frozen_string_literal: true

class PersonSerializer < ApplicationSerializer
  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |person| helpers.url_for(person) }

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties

  include ImageSerializable

  has_many :groups
  has_many :spaces
end
