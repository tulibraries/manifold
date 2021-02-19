# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorsController, type: :controller do
  render_views
  describe "the 404 page" do
    before { get :not_found }
    it "includes the renders the expected template" do
      expect(response).to render_template(:not_found)
    end

    it "includes the expected title" do
      expect(response.body).to include(I18n.t("manifold.error.not_found_header"))
    end
    it "includes the expected text" do
      expect(response.body).to include(I18n.t("manifold.error.not_found_text_html"))
    end
  end

  describe "the 500 page" do
    before { get :internal_server_error }
    it "includes the renders the expected template" do
      expect(response).to render_template(:internal_server_error)
    end

    it "includes the expected title" do
      expect(response.body).to include(I18n.t("manifold.error.internal_server_error_header"))
    end
    it "includes the expected text" do
      expect(response.body).to include(I18n.t("manifold.error.internal_server_error_html"))
    end
  end

  describe "the 503 page" do
    before { get :service_unavailable }
    it "includes the render of the expected template" do
      expect(response).to render_template(:service_unavailable)
    end

    it "includes the expected title" do
      expect(response.body).to include(I18n.t("manifold.error.service_unavailable_header"))
    end
    it "includes the expected text" do
      expect(response.body).to include(I18n.t("manifold.error.service_unavailable_html"))
    end
  end
end
