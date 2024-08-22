# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render "not_found", status: :not_found }
      format.all { render plain: t("manifold.error.not_found_text_html") , status: :not_found }
    end
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def service_unavailable
    render status: :service_unavailable
  end
end
