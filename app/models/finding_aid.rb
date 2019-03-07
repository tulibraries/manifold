# frozen_string_literal: true

class FindingAid < ApplicationRecord
  include InputCleaner

  has_paper_trail

  before_validation :sanitize_description

  serialize :subject

  belongs_to :collection

  has_many :finding_aid_responsibilities
  has_many :person, through: :finding_aid_responsibilities
end
