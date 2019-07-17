# frozen_string_literal: true

module Admin
  class PagesController < Admin::ApplicationController
    def detach
      @page = Page.find(params[:id])
      @page.document.purge
      flash[:notice] = "Document purged"
      redirect_to admin_page_path
    end
  end
end
