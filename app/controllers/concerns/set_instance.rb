# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    unless params[:id].nil?
      if model.find_by(slug: params[:id])
        model.friendly.find(params[:id])
      else
        model.find_by(id: params[:id])
      end
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
