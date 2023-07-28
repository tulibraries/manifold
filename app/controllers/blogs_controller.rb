# frozen_string_literal: true

class BlogsController < ApplicationController
  before_action :set_blog, only: [:show]
  include SerializableRespondTo

  def index
    @blogs = Blog.all

    respond_to do |format|
      format.html { redirect_to "/news" }
      format.json { render json: BlogSerializer.new(@blogs) }
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to @blog.base_url, allow_other_host: true }
      format.json { render json: BlogSerializer.new(@blog) }
    end
  end


  private
    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end
end
