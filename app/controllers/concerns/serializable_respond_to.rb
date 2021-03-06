# frozen_string_literal: true

module SerializableRespondTo
  extend ActiveSupport::Concern

  def serializable_index
    @resources = klass.all unless klass == Alert
    @resources = klass.all.where(published: true) if klass == Alert
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: klass_serializer.new(@resources) }
    end
  end

  def serializable_show
    respond_to do |format|
      format.html
      format.json { render json: klass_serializer.new(resource) }
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
end
