# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WebpagesController, type: :controller do

  before(:all) do
    @account = FactoryBot.create(:account, role: "admin")
  end

  describe "GET #edit" do
    render_views true
    before do
      sign_in(@account)
      @webpage = FactoryBot.create(:webpage, :with_file)
      @webpage.update!(title: "page saved")
    end

    it "renders edit form with updated values by default" do
      get :edit, params: { id: @webpage.to_param }
      expect(response.body).to match("page saved")
    end

    it "saves with file removed" do
      @webpage.update!(file_uploads: [])
      get :edit, params: { id: @webpage.to_param }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    before do
      sign_in(@account)
    end

    it "removes fileabilities for unselected file uploads" do
      webpage = FactoryBot.create(:webpage, :with_files)
      fileabilities = webpage.fileabilities.order(:id).to_a
      keep = fileabilities.first
      remove = fileabilities.second

      patch :update, params: {
        id: webpage.to_param,
        webpage: {
          title: webpage.title,
          file_upload_ids: [keep.file_upload_id.to_s],
          fileabilities_attributes: {
            "0" => { id: keep.id, weight: keep.weight },
            "1" => { id: remove.id, weight: remove.weight }
          }
        }
      }

      webpage.reload
      expect(webpage.file_uploads).to contain_exactly(keep.file_upload)
      expect(Fileability.exists?(remove.id)).to be(false)
    end

    it "removes external link join rows for unselected external links" do
      webpage = FactoryBot.create(:webpage, slug: "annual-report")
      keep_link = FactoryBot.create(:external_link, title: "Keep Link")
      remove_link = FactoryBot.create(:external_link, title: "Remove Link")
      webpage.update!(external_links: [keep_link, remove_link])

      join_rows = webpage.external_link_webpages.order(:id).to_a
      keep = join_rows.find { |row| row.external_link_id == keep_link.id }
      remove = join_rows.find { |row| row.external_link_id == remove_link.id }

      patch :update, params: {
        id: webpage.to_param,
        webpage: {
          title: webpage.title,
          external_link_ids: [keep_link.id.to_s],
          external_link_webpages_attributes: {
            "0" => { id: keep.id, weight: keep.weight },
            "1" => { id: remove.id, weight: remove.weight }
          }
        }
      }

      webpage.reload
      expect(webpage.external_links).to contain_exactly(keep_link)
      expect(ExternalLinkWebpage.exists?(remove.id)).to be(false)
    end
  end
end
