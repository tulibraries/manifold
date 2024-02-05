# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "email form" do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  # let(:title) { params[:title] }
  # let(:recipients) { params[:recipients] }
  let(:the_email) { ActionMailer::Base.deliveries.first }
  let(:params) { {
        form_type:,
        title:,
        recipients:,
        name: "test",
        email: "test@example.com"
      }.merge(form_params || {})}


  describe "" do
    it "renders the form" do
      get "/forms/#{form_type}", params: form_params
      expect(response).to render_template(:show)
      expect(response.body).to include(params[:title])
    end

    it "accepts information" do
      post(forms_path, params:)
      expect(the_email.subject).to eq(params[:title])
      # Test for all form params in email body except recipients or form_type
      form_params.first.second.each do |key, value|
        expect(the_email.body.raw_source).to include(value) unless [:recipients, :form_type].include? key
      end
      # Check that after the email has been delivered, the
      # form persists to the db. Hard to do in isolation
      expect(FormSubmission.take.form_type).to eq(params[:form_type])
    end
  end
end
