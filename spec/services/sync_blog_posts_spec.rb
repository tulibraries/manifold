# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::BlogPosts, type: :service do
  before(:all) do
    @sync_blog_posts = described_class.new(blog_posts_url: file_fixture("blog_posts.rss").to_path)
    @blog_posts = @sync_blog_posts.read_blog_posts
  end

  context "valid blog_posts" do
    # let(:sync_blog_posts) {  }
    # let(:blog_posts) { sync_blog_posts.read_blog_posts }

    it "extracts the blog_post hash" do
      expect(@blog_posts.first["Title"]).to match(/^A Look Back at Fall 2018 Beyond the Page Programs$/)
    end

    it "extracts all of the blog_posts" do
      expect(@blog_posts.count).to equal(37)
    end

  end

  context "write blog_post to blog_post table", :skip do
    before(:all) do
      @sync_blog_posts.sync
    end

    it "syncs blog_posts to the table"
  end

  context "trying to ingest an existing record with slight changes" do
    it "does not update the record"
  end


end
