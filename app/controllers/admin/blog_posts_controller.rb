# frozen_string_literal: true

module Admin
  class BlogPostsController < Admin::ApplicationController
    def find_resource(param)
      scoped_resource.find(param)
    end
  end
end
