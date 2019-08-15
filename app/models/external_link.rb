# frozen_string_literal: true

class ExternalLink < ApplicationRecord
  has_paper_trail
  include Validators
  include Categorizable

  before_save :link_cleanup!

  validates :title, :link, presence: true

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
