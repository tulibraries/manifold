# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogPost, type: :model do
  let (:post) { FactoryBot.build(post_type) }
  let (:post_type) { :blog_post }
  context "Validations" do
    required_fields = [
      "title",
      "publication_date",
      "path",
      "post_guid",
      "blog",
      "content_hash"
    ]
    required_fields.each do |field|
      it "raise an error when #{field} is not present" do
        post.send("#{field}=", nil)
        expect { post.save! }.to raise_error(/#{field.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe ".author" do
    context "when an associated person is present" do
      let (:post_type) { :blog_post_assoc_author }
      it "it returns the users name" do
        expect(post.author).to match(/^Zaphod Beeblebrox/)
      end
    end
    context "when an external author is present" do
      let (:post_type) { :blog_post_exteral_author }
      it "it returns the users name" do
        expect(post.author).to eql "Wint Dril"
      end
    end
    context "when neither author " do
      it "it returns the users name" do
        expect(post.author).to eql "Unknown"
      end
    end
  end

  describe ".url" do
    it "returns the full url to the blog post" do
      expect(post.url).to eql "https://sites.temple.edu/devopsing/yup-its-some-good-content"
    end
  end
end
