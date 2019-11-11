# frozen_string_literal: true

require "spec_helper"


def model_name_from_controller
  described_class.to_s.underscore.gsub(/_controller/, "").singularize
end

RSpec.shared_examples "routes_for_imageable" do

  describe "image routes for #{described_class}", type: :routing do

  let(:factory_model) { FactoryBot.create(model_name_from_controller.to_sym, :with_image) }
  let(:thumnbnail_path) { send("#{model_name_from_controller}_image_thumbnail_path", factory_model.id) }
  let(:medium_path) { send("#{model_name_from_controller}_image_medium_path", factory_model.id) }
  let(:large_path) { send("#{model_name_from_controller}_image_large_path", factory_model.id) }

  context "object has an attached image" do
    it "has route to a thumnbnail image" do
      expect(get: thumnbnail_path).to be_routable
    end

    it "has route to a medium image" do
      expect(get: medium_path).to be_routable
    end

    it "has route to a large image" do
      expect(get: large_path).to be_routable
    end


  end

  context "object does not have an attached image" do

  end

end
end
