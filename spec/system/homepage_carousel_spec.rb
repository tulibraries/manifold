# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Homepage carousel", type: :system, js: true do
  let!(:featured_events) do
    (1..4).map do |index|
      FactoryBot.create(
        :event,
        featured: true,
        title: "Featured event #{index}",
        start_time: index.days.from_now,
        end_time: (index + 1).days.from_now
      )
    end
  end

  let!(:digital_collection) do
    FactoryBot.create(:highlight, :with_image, title: "Digital collection", promote_to_dig_col: true)
  end

  before do
    visit root_path
    expect(page).to have_css("#newsCarousel .carousel-control-next")
    page.execute_script("$.fx.off = true")
  end

  it "rotates event cards forward and backward" do
    expect(event_titles).to eq(featured_events.map(&:title))

    click_carousel_control("#newsCarousel", ".carousel-control-next")
    expect(event_titles).to eq(featured_events.map(&:title).rotate)

    click_carousel_control("#newsCarousel", ".carousel-control-prev")
    expect(event_titles).to eq(featured_events.map(&:title))
  end

  it "does not jump to the top when a carousel has no overflow" do
    page.execute_script("window.scrollTo(0, 250)")
    starting_scroll_position = page.evaluate_script("window.scrollY")

    click_carousel_control("#digcolsCarousel", ".carousel-control-next")

    expect(page.evaluate_script("window.scrollY")).to eq(starting_scroll_position)
  end

  private

    def click_carousel_control(carousel_selector, control_selector)
      page.execute_script("document.querySelector('#{carousel_selector} #{control_selector}').click()")
    end

    def event_titles
      page.evaluate_script(<<~JAVASCRIPT)
        Array.from(document.querySelectorAll("#newsCarousel .carousel-item h3"))
          .map((heading) => heading.textContent.trim())
      JAVASCRIPT
    end
end
