# frozen_string_literal: true

require "rails_helper"
require "browser"
require "browser/testing.rb"

RSpec.describe WebpagesHelper, type: :helper do
  describe "render_as_phone_link_on_mobile" do
    let(:phone_number) { "123-456-789" }
    let(:link_content) {
      image_tag("phone-handle.png", class: "category-icon decorative")
    }
    let (:number_only) { render_as_phone_link_on_mobile(number: phone_number) }
    let (:number_and_link_content) {
      render_as_phone_link_on_mobile(
        number: phone_number,
        link_content:)
    }
    let (:sms_number_only) {
      render_as_phone_link_on_mobile(number: phone_number, type: "sms")
    }
    context "the browser is a mobile browser" do
      let(:browser) { Browser.new(Browser["IPHONE"]) }
      context "only a number is passed in" do
        it "returns the tel: + number as the href" do
          expect(number_only).to include("href=\"tel:#{phone_number}")
        end
        it "uses the number as the link content" do
          expect(number_only).to include(">#{phone_number}<")
        end
        context "it is an sms number" do
          it "returns sms: + number" do
            expect(sms_number_only).to include("href=\"sms:#{phone_number}")
          end
        end
      end
      context "a number and link_content are passed in" do
        it "returns the number as href" do
          expect(number_and_link_content).to include("href=\"tel:#{phone_number}")
        end
        it "uses the provided link content" do
          expect(number_and_link_content).to include(">#{link_content}<")
        end
      end
    end

    context "the browser is not a mobile browser" do
      let(:browser) { Browser.new(Browser["FIREFOX_MODERN"]) }
      context "only a number is passed in" do
        it "returns the number as plain text" do
          expect(number_only).not_to include("href=\"tel:#{phone_number}")
        end
        it "uses the number as the text" do
          expect(number_only).to eql("#{phone_number}")
        end
        context "it is an sms number" do
          it "returns sms: + number" do
            expect(sms_number_only).not_to include("href=\"sms:#{phone_number}")
          end
        end

      end
      context "a number and link_content are passed in" do
        it "just renders the link content" do
          expect(number_and_link_content).to eql("#{link_content}")
        end
      end
    end
  end
  describe "attachment_title" do
    it "returns the full title if Speaking Volumes absent" do
      expect(helper.attachment_title("Sullivan Hall")).to eq ("Sullivan Hall")
    end
    it "removes Speaking Volumes if present" do
      expect(helper.attachment_title("Speaking Volumes Spring 2023")).to eq ("Spring 2023")
    end
  end
  describe "blog and highlights" do
    # let(:category1) { FactoryBot.create(:category, name: "policy1") }
    # let(:category2) { FactoryBot.create(:category, name: "policy2") }
    let(:blog) { FactoryBot.create(:blog) }
    let(:blog_post) { FactoryBot.create(:blog_post) }
    let(:tags) { [["historynews", "history news"]] }

    it "returns blog name from id" do
      expect(helper.blog_name(blog.id)).to eq (blog.title)
    end
    it "returns blog url from id" do
      expect(helper.blog_url(blog.id)).to eq (blog.base_url)
    end
    it "returns 2-dimensional array of tags" do
      expect(helper.get_tags(blog_post.categories)).to match_array(tags)
    end
  end

  describe "etextbooks_snippet" do
    let!(:snippet) { FactoryBot.create(:snippet, slug: "etextbooks-snippet", title: " there!", description: ActionText::Content.new("Hello")) }
    it "returns hash with snippet values" do
      expect(helper.etextbooks_snippet).to eq( {description: snippet.description, title: snippet.title} )
    end
  end
end
