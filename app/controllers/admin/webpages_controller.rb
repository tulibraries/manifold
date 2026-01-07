# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable

    def resource_params
      permitted = super
      return permitted unless action_name == "update"
      return permitted unless params[:webpage]&.key?(:file_upload_ids)
      return permitted unless requested_resource

      selected_ids = Array(permitted[:file_upload_ids]).reject(&:blank?).map(&:to_i)
      attributes = (permitted[:fileabilities_attributes] || {}).to_h
      filtered_attributes = {}

      attributes.each do |key, attrs|
        attrs = attrs.to_h
        id = attrs[:id] || attrs["id"]

        if id.present?
          fileability = requested_resource.fileabilities.find_by(id: id.to_i)
          next if fileability && !selected_ids.include?(fileability.file_upload_id)
        end

        filtered_attributes[key] = attrs
      end

      if filtered_attributes.any?
        permitted[:fileabilities_attributes] = filtered_attributes
      else
        permitted.delete(:fileabilities_attributes)
      end
      permitted
      
    def scoped_resource
      resource = super
      return resource unless current_account&.student?

      resource.joins(:student_accesses)
              .where(student_accesses: { account_id: current_account.id })
              .distinct
    end
  end
end
