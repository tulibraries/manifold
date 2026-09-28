# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Webpages", type: :request do
  describe "GET /webpages" do
    it "returns JSON when requested" do
      get webpages_path, as: :json

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("application/json")
    end
  end

  describe "GET /webpages/:id" do
    let(:webpage) { FactoryBot.create(:webpage) }

    it "returns JSON when requested" do
      get webpage_path(webpage), as: :json

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("application/json")
    end
  end

  describe "GET /about" do
    let!(:parent) { FactoryBot.create(:category, slug: "about-page") }
    let!(:child_category) do
      FactoryBot.create(:category, name: "About Child Category")
    end

    before do
      Categorization.create!(
        category: parent,
        categorizable: child_category
      )
    end

    it "renders category content" do
      get webpages_about_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(child_category.name)
    end
  end

  describe "GET /visit-study" do
    let!(:parent) { FactoryBot.create(:category, slug: "visit") }
    let!(:child_category) do
      FactoryBot.create(:category, name: "Visit Child Category")
    end

    before do
      Categorization.create!(
        category: parent,
        categorizable: child_category
      )
    end

    it "renders category content" do
      get webpages_visit_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(child_category.name)
    end
  end

  describe "GET /research-services" do
    let!(:parent) do
      FactoryBot.create(:category, slug: "research-services")
    end

    let!(:child_category) do
      FactoryBot.create(:category, name: "Research Child Category")
    end

    before do
      Categorization.create!(
        category: parent,
        categorizable: child_category
      )
    end

    it "renders category content" do
      get webpages_research_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(child_category.name)
    end
  end

  describe "GET /scrc" do
    let!(:visit_links) { FactoryBot.create(:category, slug: "scrc-study") }
    let!(:collection_links) { FactoryBot.create(:category, slug: "scrc-collections") }
    let!(:collection_link) do
      FactoryBot.create(:category, name: "SCRC Collection Link")
    end
    let!(:webpage) { FactoryBot.create(:webpage, slug: "scrc") }
    let!(:intro) do
      FactoryBot.create(
        :snippet,
        slug: "scrc-homepage-intro",
        description: ActionText::Content.new("SCRC introduction")
      )
    end

    before do
      Categorization.create!(
        category: collection_links,
        categorizable: collection_link
      )
    end

    it "renders prepared page content" do
      get webpages_scrc_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("SCRC introduction")
      expect(response.body).to include(collection_link.name)
    end
  end

  describe "GET /blockson" do
    let!(:webpage) do
      FactoryBot.create(
        :webpage,
        slug: "blockson-intro",
        description: ActionText::Content.new("Blockson introduction")
      )
    end

    let!(:visit_links) { FactoryBot.create(:category, slug: "blockson-study") }
    let!(:research_links) { FactoryBot.create(:category, slug: "blockson-research") }
    let!(:visit_link) { FactoryBot.create(:category, name: "Blockson Visit Link") }
    let!(:research_link) { FactoryBot.create(:category, name: "Blockson Research Link") }
    let!(:tours) { FactoryBot.create(:category, name: "360&deg; Virtual Exhibits") }

    before do
      Categorization.create!(
        category: visit_links,
        categorizable: visit_link
      )

      Categorization.create!(
        category: research_links,
        categorizable: research_link
      )
    end

    it "renders prepared page content" do
      get webpages_blockson_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Blockson introduction")
      expect(response.body).to include(visit_link.name)
      expect(response.body).to include(research_link.name)
    end
  end

  describe "GET /lcdss" do
    let!(:visit_links) { FactoryBot.create(:category, slug: "lcdss-study") }
    let!(:research_links) { FactoryBot.create(:category, slug: "lcdss-research") }
    let!(:blog) { FactoryBot.create(:blog, title: "LCDSS Blog") }
    let!(:blog_post) do
      FactoryBot.create(
        :blog_post,
        blog:,
        title: "LCDSS Blog Post"
      )
    end
    let!(:webpage) do
      FactoryBot.create(
        :webpage,
        slug: "lcdss-intro",
        description: ActionText::Content.new("LCDSS introduction")
      )
    end

    it "renders prepared page content" do
      get webpages_lcdss_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("LCDSS introduction")
      expect(response.body).to include(blog_post.title)
    end
  end

  describe "GET /scop" do
    let!(:blog) do
      FactoryBot.create(
        :blog,
        title: "Scholarly Communications at Temple",
        slug: "scholarly-communications-at-temple"
      )
    end

    let!(:blog_post) do
      FactoryBot.create(
        :blog_post,
        blog:,
        title: "SCOP Blog Post"
      )
    end

    let!(:publishing_services) do
      FactoryBot.create(:category, slug: "publishing-services")
    end

    let!(:scholar_share) do
      FactoryBot.create(:category, slug: "tuscholarshare")
    end

    let!(:webpage) do
      FactoryBot.create(
        :webpage,
        slug: "scop-intro",
        description: ActionText::Content.new("SCOP introduction")
      )
    end

    it "renders prepared page content" do
      get webpages_scop_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("SCOP introduction")
      expect(response.body).to include(blog_post.title)
    end
  end

  describe "GET /hsl" do
    let!(:resource_links) { FactoryBot.create(:category, slug: "hsl-resources") }
    let!(:research_links) { FactoryBot.create(:category, slug: "hsl-research") }
    let!(:visit_links) { FactoryBot.create(:category, slug: "hsl-study") }
    let!(:resource_link) { FactoryBot.create(:category, name: "HSL Resource Link") }

    let!(:study_room) do
      FactoryBot.create(
        :external_link,
        slug: "hsl-study-rooms",
        title: "HSL Study Rooms"
      )
    end

    let!(:remote_learning) do
      FactoryBot.create(:webpage, slug: "online-support")
    end

    before do
      Categorization.create!(
        category: resource_links,
        categorizable: resource_link
      )
    end

    it "renders prepared page content" do
      get webpages_hsl_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(resource_link.name)
      expect(response.body).to include(study_room.link)
    end
  end

  describe "GET /" do
    let!(:cta3) do
      FactoryBot.create(
        :category,
        slug: "computers-printing-technology"
      )
    end

    let!(:cta4) do
      FactoryBot.create(
        :category,
        slug: "explore-charles"
      )
    end

    it "returns a successful response" do
      get root_path

      expect(response).to have_http_status(:success)
    end

    it "renders the highlighted exhibition before featured events" do
      exhibition = FactoryBot.create(
        :exhibition,
        title: "Highlighted Exhibition",
        start_date: Date.current,
        end_date: Date.current + 1,
        highlighted: true
      )

      FactoryBot.create(
        :event,
        title: "Featured Event",
        featured: true,
        start_time: Date.current + 1,
        end_time: Date.current + 2
      )

      get root_path

      document = Nokogiri::HTML(response.body)
      event_titles = document.css(
        "#newsCarouselItems .carousel-item .event-title"
      ).map { |node| node.text.strip }

      expect(event_titles.first).to eq(exhibition.title)
      expect(event_titles).to include("Featured Event")
    end
  end

  describe "GET /watchpastprograms/collections/:collection" do
    it "renders a collection when videos are returned" do
      videos = [{ Title: "Example Video" }]

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "collection", collection: "events")
        .and_return(videos)

      get webpages_videos_collection_path(collection: "events")

      expect(response).to have_http_status(:success)
    end

    it "redirects when the collection has no videos" do
      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "collection", collection: "missing")
        .and_return(nil)

      get webpages_videos_collection_path(collection: "missing")

      expect(response).to redirect_to(webpages_videos_all_path)
    end
  end

  describe "GET /watchpastprograms/search" do
    it "renders search results when videos are returned" do
      videos = [
        "livingstone",
        1,
        [
          {
            Id: "video-123",
            Name: "Livingstone Research Awards",
            Urls: {
              ThumbnailUrl: "https://example.com/thumbnail.jpg"
            }
          }
        ]
      ]

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "search", query: "livingstone")
        .and_return(videos)

      get webpages_videos_search_path(q: "livingstone")

      expect(response).to have_http_status(:success)
      expect(response.body).to include("livingstone")
    end

    it "redirects when no search term is provided" do
      get webpages_videos_search_path

      expect(response).to redirect_to(webpages_videos_all_path)
    end
  end

  describe "GET /watchpastprograms/show" do
    it "renders a video when a valid video is returned" do
      video = {
        Id: "video-123",
        Name: "Example Video",
        Description: "Example description"
      }

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "show", video_id: "video-123")
        .and_return(video)

      get webpages_video_show_path(id: "video-123")

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Example Video")
    end

    it "redirects when Panopto returns an invalid request" do
      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "show", video_id: "invalid")
        .and_return(Message: "The request is invalid.")

      get webpages_video_show_path(id: "invalid")

      expect(response).to redirect_to(webpages_videos_all_path)
    end

    it "redirects when no video id is provided" do
      get webpages_video_show_path

      expect(response).to redirect_to(webpages_videos_all_path)
    end
  end

  describe "GET /scrc/planyourvisit" do
    let!(:category) { FactoryBot.create(:category, slug: "scrc-study") }
    let!(:space) { FactoryBot.create(:space, slug: "scrc-reading-room") }

    it "returns a successful response" do
      get scrc_planyourvisit_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Plan Your Visit")
      expect(response.body).to include(category.name)
    end
  end

  describe "GET /news" do
    let!(:blog) do
      FactoryBot.create(
        :blog,
        title: "News Test Blog"
      )
    end

    let!(:blog_post) do
      FactoryBot.create(
        :blog_post,
        blog:,
        title: "Recent News Post"
      )
    end

    it "renders prepared page content" do
      get news_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(blog.title)
      expect(response.body).to include(blog_post.title)
    end
  end
end
