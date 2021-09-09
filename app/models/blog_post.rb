# frozen_string_literal: true

class BlogPost < ApplicationRecord
  include Validators

  belongs_to :blog
  belongs_to :person, optional: true
  validates :blog, :publication_date, :path, :post_guid, :title, :content_hash, presence: true

  def author
    @author = (person&.name || external_author_name || "Unknown")
  end

  def url
    blog.base_url + path
  end
end
