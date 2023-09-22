# frozen_string_literal: true

module SerializableRespondTo
  extend ActiveSupport::Concern

  def serializable_index
    #removes newly instantiated objects with nil actiontext values (i.e., never published)
    if (klass.has_attribute?(:description) && klass.has_attribute?(:access_description))
      @resources = klass.all.select{|k| k.description.present? && k.access_description.present?} 
    elsif (klass.has_attribute?(:description) && !klass.has_attribute?(:access_description))
      @resources = klass.all.select{|k| k.description.present?} unless klass == Alert
    else 
      @resources = klass.all
    end

    @resources = klass.all.where(published: true) if klass == Alert

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: klass_serializer.new(@resources) }
    end

  end

  def serializable_show
    respond_to do |format|!klass.has_attribute? :description
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
