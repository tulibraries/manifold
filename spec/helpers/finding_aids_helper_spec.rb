# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsHelper, type: :helper do
  describe "If the chosen subject isn't in list of subjects" do
    it "returns no links" do
      expect(subject_links([])).to match_array([])
    end
  end

  describe "It has a subject" do
    let (:subject) { "subject1" }
    it "returns a link" do
      expect(subject_links([subject])).to have_content(subject)
    end
  end

  describe "It has chosen subjects" do
    let(:subject) { "subject1" }
    let(:params) { {
        subject:
      } }
    it "returns a link" do
      link = subject_links([subject])
      expect(link.first).to have_content(subject)
    end
  end

  describe "It doesn't have chosen subject" do
    let(:subject) { "subject1" }
    let(:chosen_subject) { "subject2" }
    let(:params) { {
        subject: chosen_subject
      } }
    it "returns a link" do
      link = subject_links([subject])
      expect(link.first).to have_content(subject)
      expect(link.first).to match(/#{chosen_subject}/)
    end
  end
end
