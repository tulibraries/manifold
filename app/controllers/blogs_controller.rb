# frozen_string_literal: true

class BlogsController < ApplicationController
  before_action :set_blog, :get_posts, only: [:show]
  include SerializableRespondTo

  def index
    @blogs = Blog.all

    respond_to do |format|
      format.html
      format.json { render json: BlogSerializer.new(@blogs) }
    end
  end

  def show
    respond_to do |format|
      format.html { 
        if @posts.nil?
          binding.pry
          render "webpages/news"
        end
      }
      format.json { render json: BlogSerializer.new(@blog) }
    end
  end


  private
    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end

    def get_posts
      @posts = BlogPost.where("categories LIKE ?", "%#{params[:tag]}%") if params[:tag].present?
    end
end
