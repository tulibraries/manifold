# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/show", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "displays the sample webpage pdf" do
    @webpage = FactoryBot.create(:webpage, :with_file)
    render
    expect(rendered).to match /#{@webpage.file_uploads.first.file.attachment.blob.filename.to_s}/
  end

  it "displays multiple sample webpage pdfs" do
    @webpage = FactoryBot.create(:webpage, :with_files)
    render
    @webpage.file_uploads.each do |wp|
      expect(rendered).to match /#{wp.file.attachment.blob.filename.to_s}/
    end
  end

end
