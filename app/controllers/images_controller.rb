# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :find_parent

  def medium_image
    redirect_to_image(:index_image)
  end

  def thumbnail_image
    redirect_to_image(:thumb_image)
  end

  def large_image
    redirect_to_image(:show_image)
  end

  private
    def redirect_to_image(type)
      # type should be one of
      # :index_image, :thumb_image, :show_image
      # the image methods defined in imageable model concern
      if @parent.image.attached?
        redirect_to url_for(@parent.send(type))
      else
        raise ActionController::RoutingError.new("Image Not Attached")
      end
    end

    def find_parent
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @parent = $1.classify.constantize.find(value)
        end
      end
    end
end
