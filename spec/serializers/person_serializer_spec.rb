# frozen_string_literal: true

require "rails_helper" 
require "uri"

RSpec.describe PersonSerializer do
  let(:person) { FactoryBot.create(:person) }
  let(:serialized) { described_class.new(person) }
  
  it "doesn't raise an error when instantiated" do
    expect {serialized}.not_to raise_error
  end
  
  describe 'serialized_hash' do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :person 
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties)    
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(person)
    end

    describe 'person with photo' do
      let (:person) { FactoryBot.create(:person, :with_photo) }

      it 'has the photo and thumbnail attributes' do
        expect(data[:attributes].keys).to include(:photo, :thumbnail_photo)
      end

      describe "photo attribute" do
        it "returns an valid url" do
          photo_url = data[:attributes][:photo]
          expect(photo_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end

      describe "thumbnail_photo attribute" do
        it "returns an valid url" do
          photo_url = data[:attributes][:thumbnail_photo]
          expect(photo_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end
    end
  end

  describe 'serialized_json' do
    it "validates against the schema" do
      pending "Need to find a better schema json ruby processor. Current one doesn't support json schema v0.7"
      schema = open(Rails.root.join('app','schemas','person_schema.json')).read
      expect(JSON::Validator.validate(schema,serialized.serialized_json)).to be true
    end
    
  end
end