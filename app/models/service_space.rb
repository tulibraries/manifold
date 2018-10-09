# frozen_string_literal: true

class ServiceSpace < ApplicationRecord
  belongs_to :service
  belongs_to :space
end
