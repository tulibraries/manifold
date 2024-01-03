# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Blog", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @blog = FactoryBot.create(:blog)
  end

  after(:all) do
    Account.destroy_all
    Blog.destroy_all
  end

  context "Blog SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/blogs/#{@blog.id}")
      expect(page).to have_text(@blog.slug)
    end
  end

end
