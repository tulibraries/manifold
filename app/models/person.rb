# frozen_string_literal: true

class Person < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include Categorizable
  include Imageable
  extend FriendlyId
  friendly_id :name, use: :slugged
  friendly_id :slug_candidates, use: :slugged
  validates_presence_of :slug

  paginates_per 20

  validates :first_name, :last_name, :job_title, presence: true
  validates :email_address, presence: true, email: true
  validates :phone_number, phone_number: true
  validates :spaces, presence: true

  serialize :specialties

  auto_strip_attributes :email_address

  before_validation :normalize_phone_number
  before_validation :burpSpecialties

  has_many :member
  has_many :groups, through: :member, source: :group

  has_many :occupant
  has_many :spaces, through: :occupant, source: :space

  def slug_candidates
    [
      :name,
      [:name, :job_title],
      [:name, :job_title, :id]
    ]
  end

  def name
    "#{first_name} #{last_name}"
  end

  alias :label :name

  def burpSpecialties
    if self.specialties.is_a? Array
      self.specialties.reject! { |s| s.empty? }
    end
  end
end
