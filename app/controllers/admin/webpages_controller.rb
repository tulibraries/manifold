# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable

    def resource_params
      permitted = super
      return permitted unless action_name == "update"
      return permitted unless requested_resource

      sync_join_attributes!(
        permitted: permitted,
        ids_key: :file_upload_ids,
        attributes_key: :fileabilities_attributes,
        association_name: :fileabilities,
        associated_id_key: :file_upload_id,
        selected_id_for: ->(record) { record.file_upload_id }
      )

      sync_join_attributes!(
        permitted: permitted,
        ids_key: :external_link_ids,
        attributes_key: :external_link_webpages_attributes,
        association_name: :external_link_webpages,
        associated_id_key: :external_link_id,
        selected_id_for: ->(record) { record.external_link_id }
      )

      selected_key = permitted.delete(:featured_item_key).presence

      if permitted[:fileabilities_attributes].present?
        permitted[:fileabilities_attributes].each_value do |attrs|
          attrs[:featured] = selected_key == "Fileability:#{attrs[:id] || attrs["id"]}"
        end
      end

      if permitted[:external_link_webpages_attributes].present?
        permitted[:external_link_webpages_attributes].each_value do |attrs|
          attrs[:featured] = selected_key == "ExternalLinkWebpage:#{attrs[:id] || attrs["id"]}"
        end
      end

      ActionController::Parameters.new(permitted.to_unsafe_h).permit!
    end

    def scoped_resource
      resource = super
      return resource unless current_account&.student?

      resource.joins(:student_accesses)
              .where(student_accesses: { account_id: current_account.id })
              .distinct
    end

    private

      def sync_join_attributes!(permitted:, ids_key:, attributes_key:, association_name:, associated_id_key:, selected_id_for:)
        return unless params[:webpage]&.key?(ids_key)

        selected_ids = Array(permitted.delete(ids_key)).reject(&:blank?).map(&:to_i)
        attributes_param = permitted[attributes_key]
        attributes =
          if attributes_param.respond_to?(:to_unsafe_h)
            attributes_param.to_unsafe_h
          else
            attributes_param || {}
          end

        existing_records = requested_resource.public_send(association_name).index_by(&:id)
        attributes_by_record_id = {}

        attributes.each_value do |attrs|
          attrs =
            if attrs.respond_to?(:to_unsafe_h)
              attrs.to_unsafe_h
            else
              attrs
            end

          id = attrs[:id] || attrs["id"]
          attributes_by_record_id[id.to_i] = attrs if id.present?
        end

        filtered_attributes = {}
        next_index = 0

        existing_records.each_value do |join_record|
          attrs = (attributes_by_record_id[join_record.id] || { "id" => join_record.id.to_s }).dup

          if selected_ids.include?(selected_id_for.call(join_record))
            filtered_attributes[next_index.to_s] = attrs
          else
            filtered_attributes[next_index.to_s] = attrs.merge("_destroy" => "1")
          end

          next_index += 1
        end

        existing_selected_ids = existing_records.values.map { |record| selected_id_for.call(record) }
        new_selected_ids = selected_ids - existing_selected_ids

        new_selected_ids.each do |selected_id|
          filtered_attributes[next_index.to_s] = {
            associated_id_key.to_s => selected_id,
            "weight" => 10
          }
          next_index += 1
        end

        if filtered_attributes.any?
          permitted[attributes_key] = filtered_attributes
        else
          permitted.delete(attributes_key)
        end
      end
  end
end
