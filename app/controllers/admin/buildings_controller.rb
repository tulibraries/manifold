# frozen_string_literal: true

module Admin
  class BuildingsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable
  end
end
