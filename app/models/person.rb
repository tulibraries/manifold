# frozen_string_literal: true

class Person < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include Categorizable
  include Imageable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  serialize :specialties

  paginates_per 20

  validates :first_name, :last_name, :job_title, presence: true
  validates :email_address, presence: true, email: true
  validates :phone_number, phone_number: true
  validates :spaces, presence: true

  auto_strip_attributes :email_address

  before_validation :normalize_phone_number
  before_validation :burpSpecialties

  has_many :member, dependent: :destroy
  has_many :groups, through: :member, source: :group

  has_many :occupant, dependent: :destroy
  has_many :spaces, through: :occupant, source: :space

  def slug_candidates
    [
      :name,
      [:name, :job_title],
      [:name, :job_title, :id]
    ]
  end

  def should_generate_new_friendly_id?
    first_name_changed? || last_name_changed? || job_title_changed? || slug.blank?
  end

  scope :is_specialist, ->(specialists) {
    where.not(specialties: []) if specialists.present? && specialists == "true"
  }

  scope :with_specialty, ->(specialty) {
    where("specialties LIKE ?", "%\n- #{specialty}\n%") if specialty.present?
  }

  scope :in_department, ->(groups) {
    includes(:groups).where(groups: { "slug" => groups }).where(groups: { "group_type" => "Department" }) if groups.present?
  }

  scope :at_location, ->(space_id) {
    includes(:spaces).where(spaces: { "slug" => space_id }) if space_id.present?
  }

  def name
    "#{first_name} #{last_name}"
  end

  def label
    name
  end

  def burpSpecialties
    if self.specialties.is_a? Array
      self.specialties.reject! { |s| s.empty? }
    end
  end
end
