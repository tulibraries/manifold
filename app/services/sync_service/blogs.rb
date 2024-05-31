# frozen_string_literal: true

require "open-uri"
require "resolv-replace"

class SyncService::Blogs
  def self.call(blog: nil)
    if blog.nil?
      blogs = Blog.all
    else
      blogs = (blog.is_a? Blog) ? [ blog ] : [Blog.find(blog)]
    end
    blogs.each do |this_blog|
      new(blog: this_blog).sync_blog_posts
    end
  end

  def initialize(params = {})
    # can specify just a file path or feed_path
    @feed_uri = params[:blog].feed_path
    # if URI, prepend the base url
    @log = Logger.new("log/sync-blogs.log")
    @stdout = Logger.new(STDOUT)
    @feed_uri = "#{params[:blog].base_url}#{@feed_uri}" if params[:blog].base_url
    @blog_id = params[:blog].id
  end

  def sync_blog_posts
    blog_posts = read_blog_posts
    blog_posts.each do |p|
      create_or_update_if_needed!(p)
    end
    set_sync_time
  end

  def read_blog_posts
    # blog_feed = Nokogiri::XML(URI.open(@feed_uri, { read_timeout: Rails.configuration.sync_timeout }))
    # ruby 3.1.2 -- options hash no longer works: "no implicit conversion of Hash into String"
    blog_feed = Nokogiri::XML(URI.open(@feed_uri))
    blog_feed.xpath("//channel/item").map do |blog_post|
      blog_post_xml = blog_post.to_xml
      blog_post_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\">" + blog_post.to_xml + "</xml>"
      blog_post_xml_hash = Digest::SHA256.hexdigest(blog_post_xml)
      blog_post = Feedjira.parse(blog_post_xml).entries.first
      record_hash(blog_post, blog_post_xml_hash)
    end
  end

  def record_hash(blog_post, xml_hash)
    blog_post_hash = {
      "title" => blog_post.title,
      "content" => blog_post.content,
      "path" => blog_post.url,
      "post_guid" => blog_post.entry_id,
      "publication_date" => blog_post.published,
      "categories" => blog_post.categories.join(","),
      "blog" => Blog.find(@blog_id),
      "content_hash" => xml_hash,
    }
    blog_post_hash.merge!(author(blog_post))
  end

  def create_or_update_if_needed!(record_hash)
    # If a record already exists with this content hash, then no update needed
    unless BlogPost.exists?(content_hash: record_hash["content_hash"])
      blog_post = BlogPost.find_by(blog: @blog_id, post_guid: record_hash["post_guid"]) || BlogPost.new
      blog_post.assign_attributes(record_hash)
      blog_post.save!
    end
  end

  def author(blog_post)
    # NB: Get EITHER author OR person or external author name field.
    # - If there's a person object, then external author_name will be blank.
    # - If there's a external author_name, then there will be no person object.
    person = FuzzyFind::Person.find(blog_post.author)
    if person
      { "person" => person }
    else
      { "external_author_name" => blog_post.author }
    end
  end

  def set_sync_time
    blog = Blog.find(@blog_id)
    blog.last_sync_date = DateTime.now
    blog.save!
  end

  def stdout_and_log(message, level: :info)
    # @log.send(level, message)
    @stdout.send(level, message)
  end
end
