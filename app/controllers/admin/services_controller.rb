# frozen_string_literal: true

module Admin
  class ServicesController < Admin::ApplicationController
    include Admin::Draftable
  end
end
