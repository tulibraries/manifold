# frozen_string_literal: true

class FindingAid < ApplicationRecord
  include InputCleaner
  include Categorizable
  include Validators

  paginates_per 15


  before_save :weed_nils

  has_paper_trail

  before_validation :sanitize_description
  validates :collection_id, collection_or_subject: true

  serialize :subject

  has_many :collection_aids
  has_many :collections, through: :collection_aids

  has_many :finding_aid_responsibilities
  has_many :person, through: :finding_aid_responsibilities

  private
    # TODO: find and eliminate the cause of nil values on form submission
    def weed_nils
      subject.reject! { |s| s == "" }
    end
end
