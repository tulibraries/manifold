# frozen_string_literal: true

module Admin
  class ExhibitionsController < Admin::ApplicationController
    include Admin::Draftable
    include Admin::Detachable
  end

  def permitted_attributes
    super + [:draft_description, :publish]
  end
end
