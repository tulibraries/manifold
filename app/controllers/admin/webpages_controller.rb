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
      attributes_by_id = {}

      attributes.each do |key, attrs|
        attrs = attrs.to_h
        attributes[key] = attrs
        id = attrs[:id] || attrs["id"]
        attributes_by_id[id.to_i] = key if id.present?
      end

      requested_resource.fileabilities.each do |fileability|
        next if selected_ids.include?(fileability.file_upload_id)

        if (key = attributes_by_id[fileability.id])
          attributes[key]["_destroy"] = "1"
        else
          attributes[attributes.size.to_s] = { id: fileability.id, _destroy: "1" }
        end
      end

      permitted[:fileabilities_attributes] = attributes if attributes.any?
      permitted
    end
  end
end
