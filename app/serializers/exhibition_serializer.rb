# frozen_string_literal: true

class ExhibitionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :start_date, :end_date, :promoted_to_events
end
