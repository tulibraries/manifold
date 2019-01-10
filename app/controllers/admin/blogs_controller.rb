# frozen_string_literal: true

module Admin
  class BlogsController < Admin::ApplicationController
    def sync
      Blog.all.each do |b|
        SyncService::Blogs.call(blog: b)
      end
      flash[:notice] = "Blogs synced"
      redirect_to admin_blogs_path
    end
  end
end
