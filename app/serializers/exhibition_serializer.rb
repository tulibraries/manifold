# frozen_string_literal: true

class ExhibitionSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :title, :start_date, :end_date, :online_url
end
