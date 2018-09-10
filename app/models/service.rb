class Service < ApplicationRecord
  validates :title, :description, :intended_audience, :service_category, presence: true
end
