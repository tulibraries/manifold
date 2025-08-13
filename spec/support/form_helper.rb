# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "email form" do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  let(:the_email) { ActionMailer::Base.deliveries.first }

  describe "" do
    it "renders the form" do
      get("/forms/#{form_type}", params: form_params)
      expect(response).to render_template(:show)
      expect(response.body).to include(form_params[:form][:title])
    end

    it "accepts information" do
      post(forms_path, params: form_params)
      if ["av-requests", "copy-requests"].include? form_type
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response).to have_http_status(200)
      else
        expect(the_email.subject).to eq(form_params[:form][:title])
        # Recipients and form_type not included in email body
        form_params[:form].each do |key, value|
          expect(the_email.body.raw_source).to include(value) unless [:recipients, :form_type].include? key
        end
      end
      # Check that the form submission persists to the db.
      expect(FormSubmission.take.form_type).to eq(form_params[:form][:form_type])
    end
  end
end
