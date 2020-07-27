# frozen_string_literal: true

class ExternalLink < ApplicationRecord
  has_paper_trail
  include Validators
  include Categorizable
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  before_save :link_cleanup!

  # has_many :collection, dependent: :restrict_with_error
  has_many :webpage, dependent: :restrict_with_error
  has_many :category, dependent: :restrict_with_error
  has_many :space, dependent: :restrict_with_error
  has_many :service, dependent: :restrict_with_error
  has_many :building, dependent: :restrict_with_error

  validates :title, :link, presence: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def label
    title
  end

  def link_cleanup!
    if self.link.present?
      # if it is not a full url
      unless self.link =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
        # and it doesn't already start with /
        unless self.link.starts_with?("/")
          # prepend /
          self.link = self.link.prepend("/")
        end
      end
    end
  end
end
