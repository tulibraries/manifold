# frozen_string_literal: true

module Admin::Detachable
  extend ActiveSupport::Concern

  def detach
    klass = params[:controller].split("/").last.classify
    entity = klass.constantize.find(params[:id])
    entity.image.purge
    flash[:notice] = "Image detached"
    redirect_to url_for(controller: params[:controller], action: :show, id: params[:id], only_path: true)
  end
end
