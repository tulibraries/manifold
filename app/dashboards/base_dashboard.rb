# frozen_string_literal: true

require "administrate/base_dashboard"

class BaseDashboard < Administrate::BaseDashboard
  def tinymce?
    false
  end
end
