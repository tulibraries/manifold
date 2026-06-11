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

  before do
    allow(Cloudflare::TurnstileVerifier).to receive(:configured?).and_return(true)
    allow(Cloudflare::TurnstileVerifier).to receive(:site_key).and_return("site-key")
  end

  it "renders the widget only on form pages when configured" do
    get("/forms/#{form_type}")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("cf-turnstile")
    expect(response.body).to include("site-key")
    expect(response.body).to include("challenges.cloudflare.com/turnstile/v0/api.js")
  end

  it "rejects submissions when verification fails" do
    expect(Cloudflare::TurnstileVerifier).to receive(:verify).with(
      token: "turnstile-token",
      remote_ip: anything
    ).and_return(false)

    expect do
      post(forms_path, params: form_params)
    end.not_to change(FormSubmission, :count)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Please confirm you are human and try again.")
  end

  it "accepts submissions when verification succeeds" do
    allow(Cloudflare::TurnstileVerifier).to receive(:verify).and_return(true)

    expect do
      post(forms_path, params: form_params)
    end.to change(FormSubmission, :count).by(1)

    expect(response).to have_http_status(:redirect)
  end
end
