# frozen_string_literal: true

class ExhibitionSerializer < ApplicationSerializer
  include LinkSerializable


  attributes :title, :description, :start_date, :end_date, :promoted_to_events
end
