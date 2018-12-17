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
      blog_post_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\">" + blog_post.to_xml + "</xml>"
      #@blog_hash = blog_post_xml.to_sha5
      @blog_post = Feedjira::Feed.parse(blog_post_xml).entries.first
      #@blog_post.blog_id = 
    end
  end

  def record_hash(blog_post)
    {
      "title" => blog_post.title,
      "content" => blog_post.content,
      "path" => blog_post.url,
      "post_guid" => blog_post.entry_id,
      "publication_date" => blog_post.published,
      "categories" => blog_post.categories,
      "external_author_name" => blog_post.author,
      #"person_id" => FuzzyFind::Person.find(blog_post.author.to_s),
      #"blog_id" => blog_post.blog_id,
      #"content_hash" => blog_post.content_hash,
    }
  end
end
