# frozen_string_literal: true

require "spec_helper"

# For models that have both a single featured image and a gallery of images.
# Detaching the featured image must not disturb the gallery.
RSpec.shared_examples "detachable with gallery" do

  describe "GET /admin/#{described_class}/:id/detach" do
    let(:model) { described_class }
    let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }

    def uploaded_image
      Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/charles.jpg"), "image/jpeg")
    end

    before(:each) {
      factory_model.image.attach(uploaded_image)
      factory_model.images.attach(uploaded_image)
    }

    it "detaches the featured image from #{described_class} and leaves the gallery attached" do
      login_as(FactoryBot.create(:administrator), scope: :account)
      detach_path = ["/admin", described_class.to_s.pluralize.downcase, factory_model.id, "detach"].join("/")

      get detach_path, params: { type: "image" }

      expect(response).to have_http_status(:found)
      follow_redirect!

      expect(response).to render_template(:edit)
      factory_model.reload
      expect(factory_model.image).to_not be_attached
      expect(factory_model.images).to be_attached
    end
  end
end
