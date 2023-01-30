# frozen_string_literal: true

module Admin
  class FindingAidsController < Admin::ApplicationController
    after_action :create_json_file, only: [:update, :destroy, :create]
    include Admin::Draftable

    def create
      super
    end

    def update
      super
    end

    def destroy
      super
    end

    private

      def create_json_file
        File.open("public/finding_aids.json", "w") { |file| file.write(FindingAidSerializer.new(FindingAid.all).serializable_hash.to_json) }
      end
  end
end
