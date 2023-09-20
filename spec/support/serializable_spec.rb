# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "serializable" do
  imageClasses = ["person", "event"]
  instance = described_class.to_s.split("Controller").first.underscore.downcase.singularize

  let(:model) { instance.to_sym } # the class that includes the concern

  unless imageClasses.include?(instance)
    let(:factory_model) { FactoryBot.create(model) }
  else
    let(:factory_model) { FactoryBot.create(model, :with_image) }
  end

  it "returns valid json" do
    get :show, format: :json, params: { id: factory_model.id }
    Tempfile.open(["serialized_#{factory_model.class.to_s.underscore.downcase}-", ".json"]) do |serialized|
      serialized.write(response.body)
      serialized.close
      args = %W[validate -s app/schemas/#{factory_model.class.to_s.underscore.downcase}_schema.json -d #{serialized.path}]

      expect(system("ajv", *args)).to be
      expect(response).to have_http_status(:success)
    end
  end

end
