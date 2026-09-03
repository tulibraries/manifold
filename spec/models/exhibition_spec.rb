# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exhibition, type: :model do
  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      start_date: [Date.parse("2018/9/24"), DateTime.parse("2018/9/1")],
      end_date: [Date.parse("2018/10/24"), DateTime.parse("2018/10/10")],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        next if k == :description # Description not versionable
        exhibition = FactoryBot.create(:exhibition, k => v.first)
        exhibition.update(k => v.last)
        exhibition.save!
        expect(exhibition.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageable"
  it_behaves_like "imageables"
  it_behaves_like "event imageable"

  it "persists featured image alt text" do
    exhibition = FactoryBot.create(:exhibition, alt_text: "An open illustrated book")

    expect(exhibition.reload.alt_text).to eq("An open illustrated book")
  end

  describe "image variant preprocessing" do
    before do
      @queued = 0
      allow(PreprocessEventImageVariantsJob).to receive(:perform_later) { @queued += 1 }
    end

    it "queues derivative generation when an image is attached" do
      exhibition = FactoryBot.create(:exhibition)

      expect {
        exhibition.image.attach(
          io: File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg"
        )
      }.to change { @queued }.by(1)
    end

    it "does not queue derivative generation when other attributes change" do
      exhibition = FactoryBot.create(:exhibition, :with_image)

      expect {
        exhibition.update!(title: "A New Title")
      }.not_to change { @queued }
    end
  end
end
