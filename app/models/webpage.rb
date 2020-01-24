# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Accountable
  include Categorizable
  include SetDates
  include Validators
  include SchemaDotOrgable

  has_one_attached :document, dependent: :destroy
  # validates :document, content_type: ["application/pdf"]
  validates :title, :description, presence: true

  belongs_to :group, optional: true
  belongs_to :file_uploads, optional: true

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
