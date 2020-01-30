# frozen_string_literal: true

class ServiceGroup < ApplicationRecord
  belongs_to :service
  belongs_to :group
end
