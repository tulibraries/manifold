# frozen_string_literal: true

class Service < ApplicationRecord
  include InputCleaner
  include HasPolicies

  validates :title, :description, :intended_audience, :service_category, presence: true
  validates :related_groups, presence: true

  serialize :intended_audience

  has_many :service_space
  has_many :related_spaces, through: :service_space, source: :space

  has_many :service_group
  has_many :related_groups, through: :service_group, source: :group

  # has_many :service_policy
  # has_many :related_policies, through: :service_policy, source: :policy

  before_validation :remove_empty_audience
  before_validation :sanitize_description

  def remove_empty_audience
    # Rails tends to return an empty string in multi-selects array
    intended_audience&.reject! { |a| a.empty? }
  end

  def todays_date
    @today = Date.today
  end

  def todays_hours
    @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    unless self.hours.blank?
      todays_hours = LibraryHours.where(location_id: self.hours, date: @today).pluck(:hours).first
    end
  end
end
