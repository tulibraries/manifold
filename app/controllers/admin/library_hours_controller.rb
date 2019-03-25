# frozen_string_literal: true

module Admin
  class LibraryHoursController < Admin::ApplicationController
    def sync
      begin
        SyncService::LibraryHours.call
        flash[:notice] = "Hours synced"
        redirect_to admin_library_hours_path
      rescue
        flash[:notice] = "An error occurred during sync."
        redirect_to admin_library_hours_path
      end
    end

    # disable 'edit' and 'destroy' links
    def valid_action?(name, resource = resource_class)
      %w[new edit destroy].exclude?(name.to_s) && super
    end
  end
end
