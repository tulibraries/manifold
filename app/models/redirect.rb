# frozen_string_literal: true

class Redirect < ApplicationRecord
  before_save :ensure_starting_slash_in_legacy_path!
  before_save :manifold_path_cleanup!

  belongs_to :redirectable, polymorphic: true, optional: true

  validates :legacy_path, uniqueness: true

  def path
    redirectable ? redirectable : manifold_path
  end

  def ensure_starting_slash_in_legacy_path!
    if self.legacy_path.present?
      unless self.legacy_path.starts_with?("/")
        self.legacy_path = self.legacy_path.prepend("/")
      end
    end
  end


  def manifold_path_cleanup!
    if self.manifold_path.present?
      # make sure it is not a full url
      manifold_path = URI.parse(self.manifold_path)
      unless manifold_path.kind_of? URI::HTTP
        unless self.manifold_path.starts_with?("/")
          self.manifold_path = self.manifold_path.prepend("/")
        end
      end
    end
  end
end
