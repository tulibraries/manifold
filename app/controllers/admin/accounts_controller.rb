# frozen_string_literal: true

module Admin
  class AccountsController < Admin::ApplicationController
    # Devise has current_user hard_coded so if we us anything other than
    # user, we have no access to the devise object. So, we need to override
    # current_user to return the current account. This is needed both
    # in ApplicationController and in Admin::ApplicationController
    def current_user
      current_account
    end
    def find_resource(param)
      scoped_resource.find(param)
    end

    def destroy
      account = requested_resource
      form_infos = FormInfo.all.select { |fi|
        fi.recipients.include?(account.email)
      }

      if form_infos
        links = []
        form_infos.each do |form_info|
          links << "<a href=/admin/form_infos/#{form_info.slug}/edit>#{form_info.title}</a>"
        end

        notice = "<p class=text-start>Account could not be deleted. "
        notice +=  "It is still attached to the following Form Infos.<br />"
        notice +=  "Remove and/or replace recipient there and try again.</p>"
        links.each do |link|
          notice += "<p><strong>#{link}</strong></p>"
        end
        notice += "<br />"
        redirect_to :admin_accounts, notice:
      else
        super
      end
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_root_url, alert: t("manifold.error.access_denied")
    end
  end
end
