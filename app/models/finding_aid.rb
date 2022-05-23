# frozen_string_literal: true

class FindingAid < ApplicationRecord
  include InputCleaner
  include Categorizable
  include Draftable
  include Validators
  include SchemaDotOrgable

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  paginates_per 15
  has_paper_trail

  before_save :weed_nils
  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert
  validates :collection_id, collection_or_subject: true

  scope :has_subjects, -> { where.not(subject: []) }
  scope :has_collections, -> { where.not(collections: []) }
  scope :with_subject, ->(subjects) {
    where(subject_query(subjects), *(subjects.map { |s| "%#{s}%" })) if subjects.present?
  }
  scope :in_collection, ->(collection_id) {
    includes(:collections).where(collections: { "id" => collection_id }) if collection_id.present?
  }

  serialize :subject

  has_many :collection_aids, dependent: :destroy
  has_many :collections, through: :collection_aids

  has_many :finding_aid_responsibilities, dependent: :destroy
  has_many :person, through: :finding_aid_responsibilities

  def slug_candidates
    [
      :name,
      [:name, :identifier]
    ]
  end

  def schema_dot_org_type
    "ArchiveComponent"
  end

  def additional_schema_dot_org_attributes
    subjects = subject.map(&:inspect).join(", ") if subject.present?
    collections = collections.map(&:inspect).join(", ") if collections.present?
    {
      about: subjects,
      isPartOf: collections,
      identifier: identifier
    }
  end

  def label
    name
  end

  private
    # TODO: find and eliminate the cause of nil values on form submission
    def weed_nils
      subject.reject! { |s| s == "" } if subject.present?
    end

    def self.subject_query(subjects)
      subjects.size.times.map { |s| "finding_aids.subject LIKE ?" }.join(" AND ")
    end
end
