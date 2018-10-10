# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :building
  belongs_to :space
  belongs_to :person
end
