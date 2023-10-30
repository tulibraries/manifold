# frozen_string_literal: true

module Admin
  class FileUploadsController < Admin::ApplicationController
    include Admin::Detachable
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = FileUpload.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   FileUpload.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def destroy
      file = FileUpload.find_by(slug: params[:id])
      if file.nil?
        file = FileUpload.find_by(id: params[:id])
      end
      file_id = file.id
      webpages = Fileability.where(attachable_type: "Webpage").where(file_upload_id: file_id)
      services = Fileability.where(attachable_type: "Service").where(file_upload_id: file_id)
      groups = Fileability.where(attachable_type: "Group").where(file_upload_id: file_id)

      fileabilities = webpages + services + groups

      if fileabilities.present?


        models = [webpages, services, groups]
        links = {}

        models.each do |fileabilities|
          if fileabilities.present?
            type = fileabilities.first.attachable_type
            links[type.to_sym] = []
            fileabilities.each do |fileability|
              label = type.constantize.find(fileability.attachable_id).label
              links[fileability.attachable_type.to_sym] << "<a href=/admin/#{fileability.attachable_type.to_s.downcase.pluralize}/#{fileability.attachable_id}/edit>#{label}</a>"
            end
          end
        end
        notice = "<p class=text-start>File Upload could not be deleted. "
        notice +=  "It is still attached to the following objects.<br />"
        notice +=  "Detach from listed objects and try again.</p>"
        links.each do |link|
          notice += "<p><strong>#{link[0].to_s.pluralize}</strong></p>"
          link[1].each do |v|
            notice += "#{v}<br />"
          end
          notice += "<br />"
          redirect_to :admin_file_uploads, notice:
        end
      else
        super
      end
    end

    def permitted_attributes
      super + [fileabilties_attributes: [:weight, :id]] + [file_upload_ids]
    end
  end
end
