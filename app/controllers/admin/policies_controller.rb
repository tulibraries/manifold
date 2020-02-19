#frozen_string_literal: true

module Admin
  class PoliciesController < Admin::ApplicationController
    include Admin::Draftable
  end
end
