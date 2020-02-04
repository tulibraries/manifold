# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Accountable
  include Categorizable
  include SetDates
  include Validators
  include SchemaDotOrgable

  validates :title, :description, presence: true
  belongs_to :group, optional: true
  has_many :file_uploads, as: :attachable, dependent: :destroy

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
