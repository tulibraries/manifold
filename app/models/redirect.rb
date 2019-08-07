# frozen_string_literal: true

class Redirect < ApplicationRecord
  before_save :strip_starting_slash_in_legacy_path
  before_save :manifold_path_cleanup!

  belongs_to :redirectable, polymorphic: true, optional: true

  def path
    redirectable ? redirectable : manifold_path
  end

  def strip_starting_slash_in_legacy_path
    if self.legacy_path.present?
      self.legacy_path.gsub!(/^\//, "")
    end
  end


  def manifold_path_cleanup!
    strip_host_from_manifold_path!
    ensure_starting_slash_in_manifold_path!
  end

  def ensure_starting_slash_in_manifold_path!
    if self.manifold_path.present?
      unless self.manifold_path.starts_with?("/")
        self.manifold_path = self.manifold_path.prepend("/")
      end
    end
  end

  def strip_host_from_manifold_path!
    if self.manifold_path.present?
      self.manifold_path = URI.parse(self.manifold_path).path
    end
  end
end
