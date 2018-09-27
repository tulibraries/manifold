# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true
end
