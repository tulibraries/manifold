# frozen_string_literal: true

require "open-uri"
require "pry"

class SyncService::Blogs
  def self.call(params = {})
    new(params).sync_blog_posts
  end

  def initialize(params = {})
    # can specify just a file path or feed_path
    @feed_uri =  params[:blog].feed_path
    # if URI, prepend the base url
    @feed_uri.prepend(params[:blog].base_url) if params[:blog].base_url
    @blog_id = params[:blog].id
  end

  def sync_blog_posts
    blog_posts = read_blog_posts
    blog_posts.each do |p|
      create_or_update_if_needed!(p)
    end
  end

  def read_blog_posts
    blog_feed = Nokogiri::XML(open(@feed_uri))
    blog_feed.xpath("//channel/item").map do |blog_post|
      blog_post_xml = blog_post.to_xml
      blog_post_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\">" + blog_post.to_xml + "</xml>"
      blog_post_xml_hash = Digest::SHA1.hexdigest(blog_post_xml)
      blog_post = Feedjira::Feed.parse(blog_post_xml).entries.first
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
      # Fuzzy find record based on title and start time, and otherwise create a new one
      blog_post = FuzzyFind::BlogPost.find(
        record_hash["title"],
        addl_attribute: { post_guid: record_hash["post_guid"] }
        ) || BlogPost.new
      blog_post.assign_attributes(record_hash)
      blog_post.save!
    end
  end

  # NB: Get EITHER author OR person or external author name field.
  #     - If there's a person object, then external author_name will be blank.
  #     - If there's a external author_name, then there will be no person object.
	def author(blog_post)
		person = FuzzyFind::Person.find(blog_post.author)
		if person
			{ "person" => person }
		else
      { "external_author_name"  => blog_post.author }
		end
	end
end
