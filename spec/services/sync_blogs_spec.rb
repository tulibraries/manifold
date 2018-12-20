# frozen_string_literal: true

require "pry"
require "rails_helper"

RSpec.describe SyncService::Blogs, type: :service do
  before(:all) do
    @sync_blog = FactoryBot.create(:blog_fixture)
  end

  context "valid blog_posts" do
    before(:all) do
      blog_post_path = File.join(fixture_path, @sync_blog.feed_path)
      @sync_blog_posts = SyncService::Blogs.new(blog_posts_url: blog_post_path, blog_id: @sync_blog.id)
#      @blog_posts = @sync_blog_posts.read_blog_posts
#      @content_hash = Digest::SHA1.hexdigest(@blog_posts.to_xml)
    end

    it "extracts the blog_post title" do
      expect(@blog_posts.first.title).to match(/^A Look Back at Fall 2018 Beyond the Page Programs$/)
    end

    it "extracts all of the blog_posts" do
      expect(@blog_posts.count).to equal(246)
    end

    describe "maps blog_posts xml to db schema" do
      subject { @sync_blog_posts.record_hash(@blog_posts.first, @sync_blog, @content_hash) }

      it "maps Title to title field" do
        expect(subject["title"]).to match(@blog_posts.first.title)
      end

      it "maps Content to content field" do
        expect(subject["content"]).to match(@blog_posts.first.content)
      end

      it "maps url to path field" do
        expect(subject["path"]).to match(@blog_posts.first.url)
      end

      it "maps entry_id to post_guid field" do
        expect(subject["post_guid"]).to match(@blog_posts.first.entry_id)
      end

      it "maps published to publication_date field" do
        expect(subject["publication_date"]).to match(@blog_posts.first.published)
      end

      it "maps author to external_author_name field" do
        expect(subject["external_author_name"]).to match(@blog_posts.first.author)
      end

      it "maps categories to categories field" do
        expect(subject["categories"]).to be(@blog_posts.first.categories)
      end

      xit "maps person_id inferred from author"

      it "maps blog_id from current blog" do
        binding.pry
        expect(subject[:blog_id]).to be(@sync_blog.id)
      end

      it "maps blog entry's digest to blog entry hash field" do
        expect(subject["content_hash"]).to match(@content_hash)
      end
    end

  end

  context "write blog_post to blog_post table", :skip do
    before(:all) do
      @sync_blog_posts.sync
    end

    it "syncs blog_posts to the table"
  end

  context "fuzzy logic" do
    describe "author" do
      xit "has a person reference" do
        allow(::FuzzyFind::Person).to receive(:find).with(kind_of(String)).and_return(@person)
        internal_blog_post.sync
        event = Event.find_by(person_id: @person.id)
        expect(event.person_id).to eq @person.id
        expect(event.external_contact_name).to eq nil
      end
      xit "doesn't have a person reference" do
        allow(::FuzzyFind::Person).to receive(:find).with(kind_of(String)).and_return(nil)
        external_blog_post.sync
        event = Event.find_by(person_id: @person.id)
        expect(event).to_not be
      end
    end
  end

  context "trying to ingest an existing record with slight changes" do
    it "does not update the record"
  end

  context "trying to ingest the same record twice" do
    it "does not update the record"
  end

  context "trying to ingest the same record twice" do
    it "does not update the record"

    it "does not throw an error trying to attach image twice"

  end

  context "trying to ingest an existing record with slight changes" do
    it "does not update the record"
  end

end
