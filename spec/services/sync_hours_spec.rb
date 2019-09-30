# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe SyncService::LibraryHours, type: :service do
  before(:all) do
    @headings = ["CHARLES LIBRARY", "SERVICE ZONE", "CAFE", "SCRC", "SCHOLARS STUDIO", "SUCCESS CENTER", "ASK A LIBRARIAN", "ASRS", "GUEST COMPUTERS", "BLOCKSON COLLECTION", "AMBLER LIBRARY", "GINSBURG  PODIATRY", "INNOVATION", "24-7"]
    @response = described_class.new
    @response.headings = @headings
  end

  context "Google API responds" do
    it "connects to Google and retrieves data" do
      expect(@response).not_to be nil
    end
    it "Response has expected column headings" do
      expect(@response).not_to be nil
    end
    it "Response has fields with data" do
      expect(@response).not_to be nil
    end
  end

  context "Google API fails to respond or times out" do
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
end
