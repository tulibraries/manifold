# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/show", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "displays pdf" do
    @webpage = FactoryBot.create(:webpage, :with_file)
    render
    expect(rendered).to render_template(partial: "_attachments")
    expect(rendered).to match /#{@webpage.file_uploads.first.name}/
  end

  it "displays file upload image" do
    @webpage = FactoryBot.create(:webpage, :with_file_and_image)
    render
    expect(rendered).to render_template(partial: "_attachments")
    expect(rendered).to match /#{@webpage.file_uploads.first.image.attachment.filename.to_s}/
  end

  it "displays multiple pdfs" do
    @webpage = FactoryBot.create(:webpage, :with_files)
    render
    @webpage.file_uploads.each do |file_upload|
      expect(rendered).to match /#{file_upload.name}/
    end
  end

  it "displays a virtual tour" do
    @webpage = FactoryBot.create(:webpage, layout: "virtual-tour", virtual_tour: "http://google.com")
    render
    expect(rendered).to render_template(partial: "_virtual-tour")
    expect(rendered).to match /TOUR NAME/
    expect(rendered).to match @webpage.virtual_tour
  end

  it "displays a tutorial" do
    @webpage = FactoryBot.create(:webpage, layout: "tutorial", tutorial_path: "helpful-hints")
    render
    expect(rendered).to render_template(partial: "_tutorial")
    expect(rendered).to match /temple-library-tutorial/
    expect(rendered).to match @webpage.tutorial_path
  end

  it "displays an external link" do
    @webpage = FactoryBot.create(:webpage, :with_external_link)
    render
    expect(rendered).to match /"#{@webpage.external_link.link}/
  end

end
