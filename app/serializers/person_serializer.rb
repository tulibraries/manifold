# frozen_string_literal: true

class PersonSerializer < ApplicationSerializer
  include ImageSerializable
  include LinkSerializable

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties

  has_many :groups
  has_many :spaces
end
