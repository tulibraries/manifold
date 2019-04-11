class ImagesController < ApplicationController

  before_action :find_parent

  def index
    if @parent.photo.attached?
      redirect_to url_for(@parent.photo)
    else
      #some default image?
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
