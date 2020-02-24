# frozen_string_literal: true

module Admin
  class CategoriesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable
  end
end
