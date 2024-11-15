# frozen_string_literal: true

class ExternalLink < ApplicationRecord
  has_paper_trail
  include Validators
  include Categorizable
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  before_save :link_cleanup!

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
      link_value = URI.parse(self.link)
      unless link_value.kind_of? URI::HTTP
        # and it doesn't already start with /
        unless self.link.starts_with?("/")
          # prepend /
          self.link = self.link.prepend("/")
        end
      end
    end
  end
end
