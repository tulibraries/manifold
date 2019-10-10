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
  it "creates a file in /public" do
    create_sitemap
    expect(Pathname.new("#{Rails.root}/public/sitemap.xml.gz")).to exist
  end
end
