require 'rails_helper'

RSpec.describe PersonsController, type: :controller do

  let (:person) {
    person = FactoryBot.build(:person)
    person.save!
    person
  }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: person.id }
      expect(response).to have_http_status(:ok)
    end
  end

end
