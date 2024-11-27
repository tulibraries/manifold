# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Webpages", type: :system do
  before do
    login_as(FactoryBot.create(:administrator))
  end

  context "Create a webpage" do
    it "adds a space on creation" do
      webpage = FactoryBot.create(:webpage, :with_files)

      # Verify web page contains a file attachment
      visit admin_webpages_path + "/#{ webpage.friendly_id }"
      expect(page).to have_content(webpage.file_uploads.first.name)

      # Remove the file attachment
      visit admin_webpages_path + "/#{ webpage.friendly_id }/edit"
      find("select[id='webpage_file_upload_ids']").unselect(webpage.file_uploads.first.name)
      click_button "Update Webpage"

      # Expect the page to not have a file attachement
      expect(page).to_not have_content(webpage.file_uploads.first.name)
    end
  end

end
