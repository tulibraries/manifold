# frozen_string_literal: true

module Admin
  class ExternalLinksController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = ExternalLink.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   ExternalLink.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def destroy
      link_id = ExternalLink.find_by(slug: params[:id])
      if link_id.nil?
        link_id = ExternalLink.find_by(id: params[:id])
      end
      webpages = Webpage.where(external_link_id: link_id)
      collections = Collection.where(external_link_id: link_id)
      services = Service.where(external_link_id: link_id)
      categories = Category.where(external_link_id: link_id)
      spaces = Space.where(external_link_id: link_id)
      buildings = Building.where(external_link_id: link_id)

      attached_links = webpages + collections + services + categories + spaces + buildings

      if attached_links.present?
        models = [webpages, collections, services, categories, spaces, buildings]
        links = {}

        models.each do |model|
          if model.present?
            links[model.name.to_sym] = []
            model.each do |m|
              links[model.name.to_sym] << "<a href=/admin/#{m.class.to_s.downcase.pluralize}/#{m.id}/edit>
                                            #{m.label}</a>"
            end
          end
        end
        notice = "<p class=text-start>External Link could not be deleted. "
        notice +=  "It is still attached to the following objects.<br />"
        notice +=  "Detach from listed objects and try again.</p>"
        links.each do |link|
          notice += "<p><strong>#{link[0].to_s.pluralize}</strong></p>"
          link[1].each do |v|
            notice += "#{v}<br />"
          end
          notice += "<br />"
        end
      else
        super
      end
      redirect_to :admin_external_links, notice:
    end
  end
end
