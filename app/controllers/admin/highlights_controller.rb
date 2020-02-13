# frozen_string_literal: true

module Admin
  class HighlightsController < Admin::ApplicationController
    include Admin::Detachable

    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, "created_at"),
        params.fetch(resource_name, {}).fetch(:direction, "desc"),
      )
    end
  end
end
