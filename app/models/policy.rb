# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include InputCleaner
  include Validators
  include SchemaDotOrgable

  validates :name, :description, :effective_date, presence: true
  serialize :category

  def label
    name
  end

  def schema_dot_org_type
    "WebPage"
  end

  def additional_schema_dot_org_attributes
    {
      name: name,
      description: description
    }
  end
end
