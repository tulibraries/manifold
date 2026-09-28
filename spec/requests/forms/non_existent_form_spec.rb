# frozen_string_literal: true

require "rails_helper"

RSpec.describe "A Form that doesn't exist", type: :request do

  let(:form_type) { "nopasaurus-rex" }

  it "404's" do
    get "/forms/#{form_type}"
    expect(response.status).to eql(404)
  end

  describe "submitting" do
    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    ["nopasaurus-rex", "../layouts/application", "ir/../ir"].each do |bad_type|
      it "404's without sending or saving for form_type #{bad_type.inspect}" do
        expect {
          post forms_path, params: { form: { form_type: bad_type, name: "Ringo", email: "tu@temple.edu" } }
        }.not_to change(FormSubmission, :count)

        expect(response.status).to eql(404)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    it "404's when the form param is missing" do
      post forms_path
      expect(response.status).to eql(404)
    end
  end
end
