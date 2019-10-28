# frozen_string_literal: true

module Admin
  class RedirectsController < Admin::ApplicationController
    def find_resource(param)
      scoped_resource.find(param)
    end
  end
end
