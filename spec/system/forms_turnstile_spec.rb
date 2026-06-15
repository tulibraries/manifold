# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Forms Turnstile", type: :system, js: true do
  let(:form_type) { "library-instruction" }
  let!(:form_info) { FactoryBot.create(:form_info, slug: form_type) }

  before do
    allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(true)
    allow(Cloudflare::TurnstileVerifier).to receive(:configured?).and_return(true)
    allow(Cloudflare::TurnstileVerifier).to receive(:site_key).and_return("site-key")
  end

  it "re-renders the Turnstile widget on pageshow restore" do
    visit("/forms/#{form_type}")

    expect(page).to have_css('[data-controller="turnstile"][data-turnstile-site-key-value="site-key"]')

    page.execute_script(<<~JS)
      window.turnstile = {
        render: function(element, options) {
          element.innerHTML = '<div class="cf-turnstile-test" data-sitekey="' + options.sitekey + '"></div>';
          return "widget-id";
        }
      };

      document.dispatchEvent(new Event("turbo:load"));
    JS

    expect(page).to have_css('.cf-turnstile-test[data-sitekey="site-key"]')

    page.execute_script(<<~JS)
      document.querySelector('[data-turnstile-target="container"]').innerHTML = '';

      const event = new Event("pageshow");
      Object.defineProperty(event, "persisted", { value: true });
      window.dispatchEvent(event);
    JS

    expect(page).to have_css('.cf-turnstile-test[data-sitekey="site-key"]')
  end
end
