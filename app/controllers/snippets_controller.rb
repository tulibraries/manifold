# frozen_string_literal: true

class SnippetsController < ApplicationController
  def permitted_attributes
    super + [:draft_description, :publish]
  end
end
