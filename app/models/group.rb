# frozen_string_literal: true

class Group < ApplicationRecord
  has_paper_trail
  # include Attachable
  include Validators
  include InputCleaner
  include Categorizable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :name, :chair_dept_heads, presence: true
  validates :group_type, presence: true, group_type: true

  has_rich_text :description

  has_many :webpages, dependent: :destroy

  belongs_to :parent_group, optional: true, class_name: "Group"
  has_many :child_groups, class_name: "Group", foreign_key: "parent_group_id", dependent: :destroy, inverse_of: false

  has_many :member, dependent: :destroy
  has_many :persons, -> { order "last_name ASC" }, through: :member, source: :person, inverse_of: false

  belongs_to :space, optional: true

  has_many :group_contact, dependent: :destroy
  has_many :chair_dept_heads, through: :group_contact, source: :person

  scope :is_department, -> { where("group_type = ?", "Department") }

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end

  def label
    name
  end
end
