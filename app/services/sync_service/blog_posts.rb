# frozen_string_literal: true

require "open-uri"

class SyncService::BlogPosts
  def self.call(blog_posts_url: nil)
    new(blog_posts_url: blog_posts_url).sync
  end

  def initialize(params = {})
    @blog_postsUrl = params.fetch(:blog_posts_url) || Rails.configuration.blog_posts_feed_url
    @blog_postsDoc = Nokogiri::XML(open(@blog_postsUrl))
  end

  def sync
    read_blog_posts.each do |e|
      record = record_hash(e)
      create_or_update_if_needed!(record)
    end
  end

  def read_blog_posts
    @blog_postsDoc.xpath("//channel/item").map do |blog_post|
      blog_post_xml = blog_post.to_xml
      binding.pry
      Hash.from_xml(blog_post_xml)["item"].merge(xml: blog_post_xml)
    end
  end

end
