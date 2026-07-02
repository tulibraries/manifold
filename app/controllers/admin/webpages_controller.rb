# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable

    def resource_params
      permitted = super
      return permitted unless action_name == "update"
      return permitted unless requested_resource

      filter_join_attributes!(
        permitted: permitted,
        ids_key: :file_upload_ids,
        attributes_key: :fileabilities_attributes,
        association_name: :fileabilities,
        selected_id_for: ->(record) { record.file_upload_id }
      )

      filter_join_attributes!(
        permitted: permitted,
        ids_key: :external_link_ids,
        attributes_key: :external_link_webpages_attributes,
        association_name: :external_link_webpages,
        selected_id_for: ->(record) { record.external_link_id }
      )
      permitted
    end

    def scoped_resource
      resource = super
      return resource unless current_account&.student?

      resource.joins(:student_accesses)
              .where(student_accesses: { account_id: current_account.id })
              .distinct
    end

    private

      def filter_join_attributes!(permitted:, ids_key:, attributes_key:, association_name:, selected_id_for:)
        return unless params[:webpage]&.key?(ids_key)

        selected_ids = Array(permitted[ids_key]).reject(&:blank?).map(&:to_i)
        attributes = (permitted[attributes_key] || {}).to_h
        filtered_attributes = {}

        attributes.each do |key, attrs|
          attrs = attrs.to_h
          id = attrs[:id] || attrs["id"]

          if id.present?
            join_record = requested_resource.public_send(association_name).find_by(id: id.to_i)
            next if join_record && !selected_ids.include?(selected_id_for.call(join_record))
          end

          filtered_attributes[key] = attrs
        end

        if filtered_attributes.any?
          permitted[attributes_key] = filtered_attributes
        else
          permitted.delete(attributes_key)
        end
      end
  end
end
