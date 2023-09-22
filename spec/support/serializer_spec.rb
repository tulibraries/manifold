# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "serializer" do
  let(:model) { described_class.to_s.split("Serializer").first.underscore.downcase.singularize.to_sym } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model) }
  let(:serialized) { described_class.new(factory_model) }
  let(:descriptionless_model) { FactoryBot.create(model, descripton: nil) }
  let(:access_descriptionless_model) { FactoryBot.create(model, access_descripton: nil) }
  let(:textless_model) { FactoryBot.create(model, access_description: nil, description: nil) }
  
  it "returns valid json" do
    Tempfile.open(["serialized_#{model}", ".json"]) do |tempfile|
      tempfile.write(serialized.to_json)
      tempfile.close
      args = %W[validate -s app/schemas/#{model}_schema.json -d #{tempfile.path}]
      expect(system("ajv", *args)).to be
    end
  end

  context "excludes instances with nil actiontext values" do
    before :each do
      let(:descriptionless_model) { FactoryBot.create(model, descripton: nil)} if (factory_model.respond_to?(:description) && !factory_model.respond_to?(:access_description))
      let(:access_descriptionless_model) { FactoryBot.create(model, access_descripton: nil)} if (factory_model.respond_to?(:access_description) && !factory_model.respond_to?(:description))
      let(:textless_model) { FactoryBot.create(model, access_description: nil, description: nil)} if (factory_model.respond_to?(:description) && factory_model.respond_to?(:access_description))
    end  

    it "only includes instances with values" do
      if (factory_model.respond_to?(:description) && !factory_model.respond_to?(:access_description)) 
        expect(:serialized).to_contain descriptionless_model.label
      end
    end
  end

end
  