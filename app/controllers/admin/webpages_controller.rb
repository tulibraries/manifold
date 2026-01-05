# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable

    def scoped_resource
      resource = super
      return resource unless current_account&.student?

      resource.joins(:student_accesses)
              .where(student_accesses: { account_id: current_account.id })
              .distinct
    end
  end
end
