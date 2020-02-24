# frozen_string_literal: true

module Admin
  class SpacesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable
  end
end
