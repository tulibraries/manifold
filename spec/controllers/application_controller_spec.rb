# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  render_views
  @alert = FactoryBot.create(:alert)
  @category = FactoryBot.create(:category)

  controller do
    def test_action
      render plain: "ok"
    end
  end

  before :each do
    routes.draw do
      get "test_action" => "anonymous#test_action"
    end
  end

  it "handles db connection errors" do
    pg_connection = class_double("PG::Connection").as_stubbed_const
    allow(pg_connection).to receive(:quote_ident).and_raise(PG::Error)

    get :test_action
    expect(response).to have_http_status 200
    expect(response.body).to include "ok"
  end

end
