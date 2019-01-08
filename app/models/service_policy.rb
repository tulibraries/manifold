# frozen_string_literal: true

class ServicePolicy < ApplicationRecord
  belongs_to :service
  belongs_to :policy
end
