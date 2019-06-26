# frozen_string_literal: true

class Service < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include HasPolicies
  include SetDates
  include Categorizable

  validates :title, :description, :intended_audience, :service_category, presence: true
  validates :related_groups, presence: true

  serialize :intended_audience

  has_many :service_space
  has_many :related_spaces, through: :service_space, source: :space

  has_many :service_group
  has_many :related_groups, through: :service_group, source: :group

  has_many :service_policy
  has_many :related_policies, through: :service_policy, source: :policy

  belongs_to :external_link, optional: true

  before_validation :remove_empty_audience
  before_validation :sanitize_description

  def remove_empty_audience
    # Rails tends to return an empty string in multi-selects array
    intended_audience&.reject! { |a| a.empty? }
  end

  def label
    title
  end
end
