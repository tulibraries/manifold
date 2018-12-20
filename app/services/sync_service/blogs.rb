# frozen_string_literal: true

require "open-uri"
require "pry"

class SyncService::Blogs
  def self.call(blog_posts_url: nil)
    new(blog_posts_url: blog_posts_url).sync
  end

  def initialize(params = {})
    @blog_posts_url = params.fetch(:blog_posts_url) || Rails.configuration.blog_posts_feed_url
    @blog_id = params.fetch(:blog_id) || -1
    #@blog_posts_xml= File.read(@blog_posts_url)
    #@blog_post_entries = Feedjira::Feed.parse(@blog_posts_xml).entries
  end

  def sync
    @blogDoc = File.open(File.join(fixture_path, blog.feed_path)) { |f| Nokogiri.XML(f) }
    @blogChannel = blogDoc.xpath("//channel").first
    binding.pry
    sync_blog_posts
  end

  def sync_blog_posts
    read_blog_posts.each do |blog_post|
      record = record_hash(blog_post, @blog_id, @blog_post_hash)
      create_or_update_if_needed!(record)
    end
  end

  def read_blog_posts
    @blog_postsDoc.xpath("//channel/item").map do |blog_post|
      @content = blog_post.to_xml
      @content_hash = Digest::SHA1.hexdigest(@content)
      blog_post_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\">" + blog_post.to_xml + "</xml>"
      @blog_post = Feedjira::Feed.parse(blog_post_xml).entries.first
    end
  end

  def xml_hash(blog_post_xml)
    Digest::SHA1.hexdigest(blog_post)
  end

  def record_hash(blog_post, blog_id, blog_hash)
    binding.pry
    {
      "title" => blog_post.title,
      "content" => blog_post.content,
      "path" => blog_post.url,
      "post_guid" => blog_post.entry_id,
      "publication_date" => blog_post.published,
      "categories" => blog_post.categories,
      "external_author_name" => blog_post.author,
      #"person_id" => FuzzyFind::Person.find(blog_post.author.to_s),
      "blog_id" => blog_id,
      "content_hash" => @content_hash
    }
  end
end
