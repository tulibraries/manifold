# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "email form" do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  let(:the_email) { ActionMailer::Base.deliveries.first }
  let(:title) { I18n.t("manifold.forms.#{form_type.underscore}.title") }
  let(:params) {  { params:
      { form: {
        form_type: form_type,
        name: "test",
        email: "test@example.com"
      }.merge(form_params || {}) }
      }
    }

  describe "" do
    it "renders the form" do
      get "/forms/#{form_type}"
      expect(response).to render_template(:index)
      expect(response.body).to include(title)
    end

    it "accepts information" do
      post "/forms", params
      expect(the_email.subject).to eq(title)
      expect(the_email.body.raw_source).to include(*form_params.values)
      # Check that after the email has been delivered, the
      # form persists to the db. Hard to do in isolation
      expect(FormSubmission.take.form_type).to eq(params[:params][:form][:form_type])
    end
  end
end
