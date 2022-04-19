# frozen_string_literal: true

class PersonSerializer < ApplicationSerializer
  include ImageSerializable
  # include LinkSerializable
  # Rails interprets the persons controller to be "people" when generating the url_for.
  # This causes errors because there is no "people" controller.
  # This solution adds the link serialization here rather than kluge up the more general
  # link serializable concern with this one-off specificity.

  link :self, Proc.new { |the_object| helpers.url_for(controller: "persons",
                                                      action: :show,
                                                      id: the_object.to_param) }

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties

  has_many :groups
  has_many :buildings
end
