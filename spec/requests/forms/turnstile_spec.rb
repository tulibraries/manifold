# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cloudflare Turnstile on forms", type: :request do
  let(:form_type) { "library-instruction" }
  let!(:form_info) { FactoryBot.create(:form_info, slug: form_type) }
  let(:form_params) do
    {
      form: {
        title: form_info.title,
        form_type:,
        recipients: form_info.recipients.to_s,
        name: "Ringo",
        email: "tu@temple.edu",
        phone: "2152041234",
        department: "LTD",
        course_title: "Course Title",
        course_code: "123",
        class_time: "Time Class Meets",
        instruction_mode: "Asynchronous",
        class_days: "Day(s) Class Meets",
        number_of_students: "Student Count",
        first_choice_date: "Requested Date",
        second_choice_date: "Requested Date",
        comments: "Scope of Request"
      },
      "cf-turnstile-response" => "turnstile-token"
    }
  end

  context "when the cloudflare_turnstile feature flag is enabled" do
    before do
      allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(true)
      allow(Cloudflare::TurnstileVerifier).to receive(:configured?).and_return(true)
      allow(Cloudflare::TurnstileVerifier).to receive(:site_key).and_return("site-key")
      allow(Cloudflare::TurnstileVerifier).to receive(:secret_key).and_return("secret-key")
      allow(Cloudflare::TurnstileVerifier).to receive(:expected_hostnames).and_return(["library.temple.edu"])
    end

    it "renders the widget on form pages" do
      get("/forms/#{form_type}")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('data-turbo="false"')
      expect(response.body).to include("cf-turnstile")
      expect(response.body).to include("site-key")
      expect(response.body).to include(%(data-action="#{form_type}"))
      expect(response.body).to include("challenges.cloudflare.com/turnstile/v0/api.js")
    end

    it "rejects submissions when verification fails" do
      expect(Cloudflare::TurnstileVerifier).to receive(:verify).with(
        token: "turnstile-token",
        remote_ip: anything,
        action: form_type
      ).and_return(false)

      expect do
        post(forms_path, params: form_params)
      end.not_to change(FormSubmission, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("cf-turnstile")
      expect(response.body).to include("We couldn&#39;t verify that you&#39;re human. Please refresh the page and try again.")
    end

    it "accepts submissions when verification succeeds" do
      allow(Cloudflare::TurnstileVerifier).to receive(:verify).and_return(true)

      expect do
        post(forms_path, params: form_params)
      end.to change(FormSubmission, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end

  context "when the feature flag is enabled but Turnstile is not configured" do
    before do
      allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(true)
      allow(Cloudflare::TurnstileVerifier).to receive(:secret_key).and_return(nil)
    end

    it "rejects submissions without calling siteverify" do
      expect do
        post(forms_path, params: form_params)
      end.not_to change(FormSubmission, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(WebMock).not_to have_requested(:post, Cloudflare::TurnstileVerifier::VERIFY_URI.to_s)
    end
  end

  context "when the feature flag is enabled in the database" do
    before do
      Flipflop::Feature.create!(key: "cloudflare_turnstile", enabled: true)
      allow(Cloudflare::TurnstileVerifier).to receive(:verify).and_return(false)
    end

    it "cannot be switched off by a client cookie" do
      expect do
        post(forms_path, params: form_params, headers: { "Cookie" => "cloudflare_turnstile=0" })
      end.not_to change(FormSubmission, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Cloudflare::TurnstileVerifier).to have_received(:verify)
    end
  end

  it "masks the Turnstile token in logs and error reports" do
    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    expect(filter.filter(form_params)["cf-turnstile-response"]).to eq("[FILTERED]")
  end

  context "when the cloudflare_turnstile feature flag is disabled" do
    before do
      allow(Flipflop).to receive(:cloudflare_turnstile?).and_return(false)
    end

    it "does not render the widget on form pages" do
      get("/forms/#{form_type}")

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("cf-turnstile")
      expect(response.body).not_to include("challenges.cloudflare.com/turnstile/v0/api.js")
    end

    it "accepts submissions without a turnstile token" do
      expect do
        post(forms_path, params: form_params)
      end.to change(FormSubmission, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
