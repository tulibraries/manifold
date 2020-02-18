# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Accountable
  include Categorizable
  include Draftable
  include SetDates
  include Validators
  include SchemaDotOrgable

  has_one_attached :document, dependent: :destroy

  has_draft :description

  # validates :document, content_type: ["application/pdf"]
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
