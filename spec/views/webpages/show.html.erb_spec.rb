# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/show", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "displays the sample webpage pdf" do
    @webpage = FactoryBot.create(:webpage, :with_file)
    render
    expect(rendered).to render_template(partial: "_attachments")
    expect(rendered).to match /#{@webpage.file_uploads.first.name}/
    expect(rendered).to match /-- View PDF/
  end

  it "displays multiple sample webpage pdfs" do
    @webpage = FactoryBot.create(:webpage, :with_files)
    render
    @webpage.file_uploads.each do |wp|
      expect(rendered).to match /#{wp.name}/
    end
  end

  it "displays a virtual tour" do
    @webpage = FactoryBot.create(:webpage, layout: "virtual-tour", virtual_tour: "http://google.com")
    render
    expect(rendered).to render_template(partial: "_virtual-tour")
    expect(rendered).to match /TOUR NAME/
    expect(rendered).to match @webpage.virtual_tour
  end

  it "displays an external link" do
    @webpage = FactoryBot.create(:webpage, :with_external_link)
    render
    expect(rendered).to match /"#{@webpage.external_link.link}/
  end


  it "excludes non-categories for parsing menu sections" do
    # @books = assign(:books, [book])
    # @results = assign(:results, true)
    @parent_category = FactoryBot.create(:category, slug: "about-page", categories: [@parent_category])
    @child_category = FactoryBot.create(:category, slug: "welcome", categories: [@parent_category])
    @webpage1 = FactoryBot.create(:webpage, categories: [@parent_category])
    @space = FactoryBot.create(:space, categories: [@parent_category])
    @webpage2 = FactoryBot.create(:webpage, categories: [@child_category])
    render
    expect(rendered).to match /#{@webpage2.label}/
    expect(rendered).to match /#{@child_category.label}/
    expect(rendered).to_not match /#{@parent_category.label}/
    expect(rendered).to_not match /#{@webpage1.label}/
    expect(rendered).to_not match /#{@space.label}/
  end
end
