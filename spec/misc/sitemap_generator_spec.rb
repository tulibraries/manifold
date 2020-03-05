# frozen_string_literal: true

require "rails_helper"
require "rake"
Rails.application.load_tasks

RSpec.describe "Running the sitemap generator rake task with our config" do
  let(:create_sitemap) {
    Rake::Task["sitemap:clean"].invoke
    Rake::Task["sitemap:create"].invoke
  }
  it "does not throw an error" do
    expect { create_sitemap }.not_to raise_error
  end
  it "puts the sitemap to aws" do
    create_sitemap
    expect(WebMock).to have_requested(:put, /.*\.amazonaws\.com\/sitemap\.xml\.gz/)
  end
end
