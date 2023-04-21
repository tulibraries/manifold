# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe SyncService::Blogs, type: :service do
  before(:all) do
    @person = FactoryBot.create(:person)
    @blog = FactoryBot.create(:blog)
  end

  context "Aggregate blog feed" do
    it "Gets all of the blog posts in a feed" do
      @blog_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_posts.rss", id: @blog.id)
      @sync_blogs = described_class.new(blog: @blog_feed)
      posts = @sync_blogs.read_blog_posts
      expect(posts.count).to eq 3
    end

    it "Reads internal authors" do
      @blog_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_post_internal_author.rss", id: @blog.id)
      @sync_blogs = described_class.new(blog: @blog_feed)
      posts = @sync_blogs.read_blog_posts
      expect(posts.last["person"].first_name).to match(/^Zaphod$/)
      expect(posts.last["person"].last_name).to match(/^Beeblebrox \d+$/)
    end
  end

  context "write blog post to blog post table" do
    before(:all) do
      @blog_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_posts.rss", id: @blog.id)
      @sync_blogs = described_class.new(blog: @blog_feed)
      @sync_blogs.sync_blog_posts
    end
    it "Saves to blog_post table" do
      expect(BlogPost.find_by(title: "First Post")).to be
      expect(BlogPost.find_by(title: "Second Post")).to be
      expect(BlogPost.find_by(title: "Third Post")).to be
    end
  end

  context "trying to ingest the same record twice" do
    before(:all) do
      @blog_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_post_internal_author.rss", id: @blog.id)
      @sync_blogs = described_class.new(blog: @blog_feed)
    end

    it "does not update the record" do
      @sync_blogs.sync_blog_posts
      first_time = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.").updated_at
      @sync_blogs.sync_blog_posts
      second_time = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.").updated_at
      expect(first_time).to eql second_time
    end
  end

  context "trying to update the same record" do
    before(:all) do
      @original_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_post_internal_author.rss", id: @blog.id)
      @original_sync = described_class.new(blog: @original_feed)
      @modified_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_post_internal_author_modified.rss", id: @blog.id)
      @modified_sync = described_class.new(blog: @modified_feed)
    end

    it "does updates the record" do
      @original_sync.sync_blog_posts
      first_time = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.").updated_at
      @modified_sync.sync_blog_posts
      second_time = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.").updated_at
      expect(first_time).to_not eql second_time
    end
  end

  context "delete and restore post" do
    before(:all) do
      @blog_feed = OpenStruct.new(feed_path: "#{fixture_path}/blog_post_internal_author.rss", id: @blog.id)
      @sync_blogs = described_class.new(blog: @blog_feed)
    end

    it "does updates the record" do
      @sync_blogs.sync_blog_posts
      blog_post = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.")
      expect(blog_post).to be
      BlogPost.destroy(blog_post.id)
      blog_post = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.")
      expect(blog_post).to_not be
      @sync_blogs.sync_blog_posts
      blog_post = BlogPost.find_by(title: "Total Perspective Vortex: What I saw.")
      expect(blog_post).to be
    end
  end

  context "sync timeout" do
    let(:feed_path) { "#{fixture_path}/blog_post_internal_author.rss"  }

    xit "passes timeout to http request" do
      skip("ruby 3.1.2 -- options hash no longer works: 'no implicit conversion of Hash into String'")
      expect(URI).to receive(:open).with(feed_path, { read_timeout: Rails.configuration.sync_timeout })
      blog_feed = OpenStruct.new(feed_path:, id: @blog.id)
      sync_blogs = described_class.new(blog: blog_feed)
      sync_blogs.read_blog_posts
    end
  end
end
