# frozen_string_literal: true

class Service < ApplicationRecord
  include InputCleaner

  validates :title, :description, :intended_audience, :service_category, presence: true
  validates :related_groups, presence: true

  serialize :intended_audience

  has_many :service_space
  has_many :related_spaces, through: :service_space, source: :space

  has_many :service_group
  has_many :related_groups, through: :service_group, source: :group

  before_validation :remove_empty_audience
  before_validation :sanitize_description

  def remove_empty_audience
    # Rails tends to return an empty string in multi-selects array
    intended_audience&.reject! { |a| a.empty? }
  end
end
