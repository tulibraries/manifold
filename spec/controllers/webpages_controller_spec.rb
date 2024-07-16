# frozen_string_literal: true

require "rails_helper"
require "net/http"
require "webmock/rspec"
require "vcr"

RSpec.describe WebpagesController, type: :controller do

  let(:webpage) { FactoryBot.create(:webpage) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:webpage) { FactoryBot.create(:webpage) }

    it "returns html by default success" do
      get :show, params: { id: webpage.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #tudsc" do
    let!(:visit_links) { FactoryBot.create(:category, slug: "lcdss-study") }
    let!(:research_links) { FactoryBot.create(:category, slug: "lcdss-research") }
    let!(:event_links) { nil }
    let(:blog) { FactoryBot.create(:blog, slug: "lcdss-blog") }
    let(:blog_post) { FactoryBot.create(:blog_post) }
    let(:webpage) { FactoryBot.create(:webpage, slug: "lcdss-intro") }

    it "returns a success response" do
      blog.slug = "lcdss-blog"
      blog.blog_posts << blog_post
      blog.save
      get :tudsc
      expect(response).to be_successful
    end
  end

  describe "GET #scop" do
    let(:blog) { FactoryBot.create(:blog, title: "Scholarly Communications at Temple", slug: "scholarly-communications-at-temple") }
    let(:category) { FactoryBot.create(:category, slug: "publishing_services") }
    let(:category2) { FactoryBot.create(:category, slug: "tuscholarshare") }
    let(:webpage) { FactoryBot.create(:webpage, slug: "scop-intro", categories: [category, category2]) }

    it "returns a success response" do
      get :scop
      expect(response).to be_successful
    end
  end

  describe "GET #hsl" do
    let!(:resource_links) { FactoryBot.create(:category, slug: "hsl-resources").items }
    let!(:research_links) { FactoryBot.create(:category, slug: "hsl-research").items }
    let!(:visit_links) { FactoryBot.create(:category, slug: "hsl-study").items }
    let!(:event_links) { nil }
    let(:study_room) { FactoryBot.create(:external_link, slug: "hsl-study-rooms") }
    let(:remote_learning) { FactoryBot.create(:webpage, slug: "online-support") }
    let(:webpage) { FactoryBot.create(:webpage, slug: "hsl-intro", categories: [category, category2]) }
    let(:hours) {
      VCR.use_cassette("todays_hours") do
        Google::SheetsConnector.call(feature: "hours", scope: "charles")
      end
    }

    it "returns a success response" do
      get :hsl
      expect(response).to be_successful
    end
  end

  describe "GET #home" do
    let!(:highlights) { FactoryBot.create(:highlight, promoted: true) }
    let!(:featured_events) { nil }
    let!(:cta3) { FactoryBot.create(:category, slug: "computers-printing-technology") }
    let!(:cta4) { FactoryBot.create(:category, slug: "explore-charles") }

    it "returns a success response" do
      VCR.use_cassette("todays_hours") do
        get :home
        expect(response).to be_successful
      end
    end
  end

  describe "GET #scrc" do
    let!(:visit_links) { FactoryBot.create(:category, slug: "scrc-study").items }
    let!(:collection_links) { FactoryBot.create(:category, slug: "scrc-collections").items }
    let!(:webpage) { FactoryBot.create(:webpage, slug: "scrc-intro") }
    let!(:intro) { FactoryBot.create(:snippet, slug: "scrc-homepage-intro") }

    it "returns a success response" do
      get :scrc
      expect(response).to be_successful
    end
  end

  describe "GET #blockson" do
    let!(:webpage) { FactoryBot.create(:webpage, slug: "blockson-intro") }
    let!(:visit_links) { FactoryBot.create(:category, slug: "blockson-study").items }
    let!(:research_links) { FactoryBot.create(:category, slug: "blockson-research").items }
    let!(:events) { nil }
    let!(:tours) { FactoryBot.create(:category, name: "360&deg; Virtual Exhibits") }
    let!(:tour_links) { nil }

    it "returns a success response" do
      get :blockson
      expect(response).to be_successful
    end
  end

  describe "webpages#news" do
    let(:blog_post) { FactoryBot.create(:blog_post) }
    let(:highlight) { FactoryBot.create(:highlight) }
    let(:blog) { blog_post.blog }

    before :each do
      get :news
      blogs = assigns(:blogs)
      blogposts = assigns(:blog_posts)
      highlights = assigns(:highlights)
      expect(response).to be_successful
    end

    it "returns blog list" do
      assert_equal Blog.all, assigns(:blogs)
    end
    it "returns blog posts" do
      assert_equal BlogPost.all.order(:updated_at).reverse.take(3), assigns(:blogposts)
    end
    it "returns highlights" do
      assert_equal Highlight.with_image.where(promoted: true).take(3), assigns(:highlights)
    end
  end

  describe "webpages#video_search" do
    it "redirects page when video not found" do
      get :videos_search, params: { query: "non-existant" }
      expect(response).to have_http_status(302)
    end
  end

  it_behaves_like "serializable"

end
