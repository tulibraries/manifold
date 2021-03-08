# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable

    def detach
      @webpage = Webpage.find(params[:id])
      @webpage.document.purge
      flash[:notice] = "Document purged"
      redirect_to admin_webpage_path
    end

    def detach_epub
      @webpage = Webpage.find(params[:id])
      @webpage.remove_epub!
      @webpage.save!
      flash[:notice] = "Epub removed"
      redirect_to admin_webpage_path
    end
  end
end
