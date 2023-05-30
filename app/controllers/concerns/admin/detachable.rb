# frozen_string_literal: true

module Admin::Detachable
  extend ActiveSupport::Concern

  def detach
    klass = params[:controller].split("/").last.classify
    entity = klass.constantize.find(params[:id])
    type = params[:type]

    if klass == "FileUpload"    # some models now have more than one attachable type
      if type == "file"
        entity.file.purge
        flash[:notice] = "File detached"
      elsif type == "image"
        entity.image.purge
        flash[:notice] = "Image detached"
      end if params[:type]
    else
      if entity.respond_to?(:images) && entity.images.size > 0
        entity.images.find(params[:attachment_id]).purge
      else
        entity.image.purge
      end
      flash[:notice] = "Image removed"
    end

    redirect_to url_for(controller: params[:controller], action: :edit, id: params[:id], only_path: true)
  end
end
