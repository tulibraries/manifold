# frozen_string_literal: true

class LibraryHours < ApplicationRecord
  validates :location_id, :date, :hours, presence: true

  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :service, optional: true
end
