# frozen_string_literal: true

require "rails_helper" 

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

    describe 'person with photo' do
      let (:person) { FactoryBot.create(:person, :with_photo) }

      it 'has the photo and thumbnail attributes' do
        expect(data[:attributes].keys).to include(:photo, :thumbnail_photo)
      end
    end
  end
end