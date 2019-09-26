# frozen_string_literal: true

class FindingAid < ApplicationRecord
  include InputCleaner
  include Categorizable

  paginates_per 15


  before_save :weed_nils

  has_paper_trail

  before_validation :sanitize_description

  serialize :subject

  has_many :collection_aids
  has_many :collections, through: :collection_aids

  has_many :finding_aid_responsibilities
  has_many :person, through: :finding_aid_responsibilities

  def label
    name
  end

  private
    # TODO: find and eliminate the cause of nil values on form submission
    def weed_nils
      subject.reject! { |s| s == "" }
    end
end
