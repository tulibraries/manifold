# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Forms", type: :request do
  describe "POST /forms" do
    let!(:form_info) { FactoryBot.create(:form_info, slug: "feedback-form") }
    let(:form_params) do
      {
        form_type: form_info.slug,
        title: "Feedback Form",
        name: "Tester",
        email: "tester@example.com"
      }
    end

    before do
      allow(FormSubmission).to receive(:create)
      allow(ExcelUpdateJob).to receive(:perform_later)
    end

    it "handles SMTP read timeouts gracefully" do
      allow(Form).to receive(:new).and_wrap_original do |method, *args|
        form = method.call(*args)
        allow(form).to receive(:deliver).and_raise(Net::ReadTimeout)
        form
      end

      post(forms_path, params: { form: form_params })

      expect(response).to redirect_to(forms_path(success: "false"))
    end
  end
end
