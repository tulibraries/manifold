# frozen_string_literal: true

module SerializableRespondTo
  extend ActiveSupport::Concern

  def serializable_index
    @resources = klass.all unless klass == Alert
    @resources = Rails.cache.fetch("AlertsDBQueryCache") { klass.all.where(published: true) if klass } == Alert
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render_json(@resources) }
    end
  end

  def serializable_show
    respond_to do |format|
      format.html
      format.json { rendor_json(resource) }
    end
  end

  private

    def klass
      controller_name.singularize.camelize.constantize
    end

    def klass_serializer
      (controller_name.singularize.camelize + "Serializer").constantize
    end

    def resource
      instance_variable_get("@#{controller_name.singularize}")
    end

    def render_json(resource)
      Rails.cache.fetch(klass_serializer.to_s) do
        render json: klass_serializer.new(resource)
      end
    end
end
