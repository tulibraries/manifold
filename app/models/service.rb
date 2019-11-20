# frozen_string_literal: true

class Service < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include Draftable
  include InputCleaner
  include HasPolicies
  include SetDates
  include SchemaDotOrgable

  validates :title, :description, :intended_audience, presence: true

  serialize :intended_audience

  belongs_to :external_link, optional: true

  has_draft :description, :access_description

  before_validation :remove_empty_audience
  before_validation :sanitize_description

  def remove_empty_audience
    # Rails tends to return an empty string in multi-selects array
    intended_audience&.reject! { |a| a.empty? }
  end

  def label
    title
  end

  def schema_dot_org_type
    "WebPage"
  end

  def additional_schema_dot_org_attributes
    {
      name: title,
      description: description
    }
  end
end
