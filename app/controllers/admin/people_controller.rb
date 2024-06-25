# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Admin::Detachable
    def destroy
      person = requested_resource
      groups = Group.all.select { |group| group.chair_dept_heads.include?(person) }
      if groups.present?
        links = []
        groups.each do |group|
          links << "<a href=/admin/groups/#{group.slug}/edit>#{group.label}</a>"
        end

        notice = "<p class=text-start>#{person.label} could not be deleted. "
        notice +=  "They are still attached to the following Groups as Chair/Dept head.<br />"
        notice +=  "Remove and/or replace them there and try again.</p>"
        links.each do |link|
          notice += "<p><strong>#{link}</strong></p>"
        end
        notice += "<br />"
        redirect_to :admin_people, notice:
      else
        super
      end
    end
  end
end
