# frozen_string_literal: true

class BlogPostsController < ApplicationController
  before_action :get_posts, only: [:index]

  def index
    if @posts.nil?
      redirect_to "/news"
    end
  end

  private
    def get_posts
      @posts = BlogPost.where("categories LIKE ?", "%#{params[:tag]}%") if params[:tag].present?
    end
end
