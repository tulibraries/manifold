# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "detachable" do

  describe "GET /admin/#{described_class}/:id/detach" do
    let(:model) { described_class } # the class that includes the concern
    let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }

    before(:each) {
      file_path = Rails.root.join("spec/fixtures/charles.jpg")
      file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
      if factory_model.respond_to?(:images)
        factory_model.images.attach(file)
      else
        factory_model.image.attach(file)
      end
    }

    it "detaches image from #{described_class}" do
      login_as(FactoryBot.create(:administrator), scope: :account)
      show_page = ["/admin", described_class.to_s.pluralize.downcase, factory_model.id].join("/")
      get show_page
      expect(response).to render_template(:show)
      expect(response.body).to include("charles.jpg")

      if factory_model.respond_to?(:images)
        get "#{show_page}/detach?attachment_id=#{factory_model.images.attachments.first.id}"
      else
        get "#{show_page}/detach"
      end
      follow_redirect!

      expect(response).to render_template(:edit)
      expect(response.body).to_not include("charles.jpg")
    end
  end
end
