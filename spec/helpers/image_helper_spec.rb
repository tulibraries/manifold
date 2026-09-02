# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImageHelper, type: :helper do
  describe "render_image" do
    it "renders processed event images through the Active Storage proxy route" do
      event = FactoryBot.create(:event, :with_processed_image, alt_text: "Proxy caption")
      html = helper.render_image(event)

      expect(html).to include("/rails/active_storage/blobs/proxy/")
      expect(html).not_to include("/rails/active_storage/representations/")
    end

    it "uses an event's supplied alt text" do
      event = FactoryBot.create(:event, :with_processed_image, alt_text: "A descriptive caption")

      expect(helper.render_image(event)).to include('alt="A descriptive caption"')
    end

    it "uses a title-based fallback alt text for an event" do
      event = FactoryBot.create(:event, :with_processed_image, title: "Poetry Reading", alt_text: nil)

      expect(helper.render_image(event)).to include('alt="Event image for Poetry Reading"')
    end

    it "renders the Temple T placeholder when an event has no image" do
      event = FactoryBot.create(:event, alt_text: "Ignored without an image")

      html = helper.render_image(event)

      expect(html).to match(%r{assets/T})
      expect(html).to include('alt="Temple T Logo"')
    end

    it "links an event index image to the event" do
      event = FactoryBot.create(:event, :with_processed_image, alt_text: "Thumbnail caption")
      html = helper.render_image(event, variant: :index)

      expect(html).to include('alt="Thumbnail caption"')
      expect(html).to include(%Q(href="#{event_path(event.id)}"))
    end

    it "renders the index placeholder when an event has no image" do
      event = FactoryBot.create(:event)
      html = helper.render_image(event, variant: :index)

      expect(html).to match(%r{assets/T})
      expect(html).to include('alt="Temple T Logo"')
    end

    it "links an event featured image to the event" do
      event = FactoryBot.create(:event, :with_processed_image, alt_text: "Featured caption")
      html = helper.render_image(event, variant: :featured)

      expect(html).to include('alt="Featured caption"')
      expect(html).to include(%Q(href="#{event_path(event.id)}"))
      expect(html).not_to include("target=")
    end

    it "uses a title-based fallback alt text for an event featured image" do
      event = FactoryBot.create(:event, :with_processed_image, title: "Poetry Reading", alt_text: nil)

      expect(helper.render_image(event, variant: :featured)).to include('alt="Event image for Poetry Reading"')
    end

    it "renders the featured placeholder when an event has no image" do
      event = FactoryBot.create(:event)
      html = helper.render_image(event, variant: :featured)

      expect(html).to include('class="events-default"')
      expect(html).to include('alt="Temple T Logo"')
    end

    it "renders an exhibition's featured image and links to the exhibition" do
      exhibition = FactoryBot.create(:exhibition, :with_processed_image, title: "Book Arts", alt_text: "Open illustrated book")

      html = helper.render_image(exhibition, variant: :index)

      expect(html).to include('alt="Open illustrated book"')
      expect(html).to include(%Q(href="#{exhibition_path(exhibition)}"))
    end

    it "uses an exhibition-specific fallback alt text" do
      exhibition = FactoryBot.create(:exhibition, :with_processed_image, title: "Book Arts", alt_text: nil)

      expect(helper.render_image(exhibition)).to include('alt="Exhibition image for Book Arts"')
    end

    it "sizes an index image with the 5:3 padded index derivative" do
      event = FactoryBot.create(:event, :with_processed_image)

      expect(event).to receive(:index_image).at_least(:once).and_call_original
      helper.render_image(event, variant: :index)
    end

    it "sizes a featured image with the 5:3 padded featured derivative" do
      event = FactoryBot.create(:event, :with_processed_image)

      expect(event).not_to receive(:custom_image)
      expect(event).to receive(:featured_image).at_least(:once).and_call_original
      helper.render_image(event, variant: :featured)
    end

    it "sizes a show image with fit_image, which is not aspect-ratioed" do
      event = FactoryBot.create(:event, :with_processed_image)

      expect(event).to receive(:fit_image).with(600, 600).at_least(:once).and_call_original
      helper.render_image(event)
    end

    it "sizes an exhibition featured image with the same padded derivative as an event" do
      exhibition = FactoryBot.create(:exhibition, :with_processed_image)

      expect(exhibition).not_to receive(:custom_image)
      expect(exhibition).to receive(:featured_image).at_least(:once).and_call_original
      helper.render_image(exhibition, variant: :featured)
    end
  end
end
