# frozen_string_literal: true

module Admin
  class CollectionsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable
    def destroy
      collection = requested_resource
      if collection.finding_aids.present?
        links = []
        collection.finding_aids.take(5).each do |fa|
          links << "<a href='/admin/finding_aids/#{fa.slug}/edit'>#{fa.label}</a><br />"
        end

        notice = "<p class=text-start><strong>#{collection.label}</strong> could not be deleted.<br />"
        notice += "It still has finding aids attached.<br />"
        links.each do |link|
          notice += link
        end
        notice += "<p>If you require help, please contact the help desk at tuhelp@temple.edu to request a data migration.</p>"
        notice += "<p class='text-center'><a href='/admin/finding_aids'>Finding Aids</a></p>"
        redirect_to :admin_collections, notice:
      else
        super
      end
    end
  end
end
