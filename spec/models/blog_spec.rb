# frozen_string_literal: true

require "rails_helper"

RSpec.describe Blog, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end


  let(:blog) { FactoryBot.build(:blog) }

  context "Validations" do
    context "check for presence" do
      required_fields = ["title", "base_url"]
      required_fields.each do |field|
        it "raises an error when #{field} is not present" do
          blog.update_attribute(field, "")
          expect { blog.save! }.to raise_error(/#{field.humanize(capitalize: true)} can't be blank/)
        end
      end
    end
    context "checks for a well formed url" do
      it "raises and error when an invalid url is submitted" do
        expect { FactoryBot.create(:blog_bad_url) }.to raise_error(/#{I18n.t('fortytude.error.invalid_url')}/)
      end
    end
  end

  context "Default values" do
    context "when no value is supplied for" do
      context ":public_status" do
        it "returns false" do
          expect(blog.public_status).to be false
        end
      end
      context ":feed_path" do
        it 'returns "/feed"' do
          expect(blog.feed_path).to eql "/feed"
        end
      end
    end
  end
  context "overriding defaults" do
    context "when a value is supplied for" do
      context ":public_status" do
        it "returns true" do
          expect(FactoryBot.build(:blog_with_public_status).public_status).to be true
        end
      end
      context ":feed_path" do
        it 'returns "/weird-feed"' do
          expect(FactoryBot.build(:blog_with_feed_path).feed_path).to eql "/weird-feed"
        end
      end
    end
  end
end
