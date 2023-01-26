# frozen_string_literal: true

module FindingAidsHelper
  def get_collection_name(collections, id)
    the_name = ""
    collections.each do |col|
      if col.id == id.to_i
        the_name = col.name
      end
    end
    the_name
  end

  def filter_tags_aids(collections)
    tags = []
    unless params[:collection].nil?
      # tags << "#{get_collection_name(collections, params[:collection])}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except(:collection).merge(page: 1))}\">X</a>"
    end
    unless params[:subject].nil?
      subjects = params[:subject].kind_of?(Array) ? params[:subject].join(",").split(",") : params[:subject].split(",")
      subjects.each do |subject|
        tags << "#{subject}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except("," + subject).merge(page: 1))}\">X</a>"
      end
    end
    tags
  end


  def subject_links(subjects)
    links = []
    unselected_links = []
    if subjects.present?
      if params[:subject].present?

        subjects.each do |subject|

          chosen_subjects = params[:subject].kind_of?(Array) ? params[:subject].join(",").split(",") : params[:subject].split(",")

          if chosen_subjects.include?(subject)
            subject_removed = chosen_subjects.reject { |sub| sub == subject }.uniq.join(",")
            link = '<li class="active"> ' + subject + '
                      <span class="clear-filter">
                        <a href="' + finding_aids_path(request.query_parameters.except(:search).merge(subject: subject_removed, page: 1)) + '" data-turbo-frame="_top">X</a>
                      </span>
                    </li>'
            links << link
          else
            chosen_subjects = chosen_subjects.split(",").push(subject).uniq.join(",")
            link = '<li><a href="' + finding_aids_path(request.query_parameters.except(:search).merge(subject: chosen_subjects, page: 1)) + '" data-turbo-frame="_top"> ' + subject + "</a></li>"
            unselected_links << link
          end
        end

      else
        subjects.each do |subject|
          link = '<li><a href="' + finding_aids_path(request.query_parameters.except(:search).merge(subject: subject, page: 1)) + '" data-turbo-frame="_top"> ' + subject + "</a></li>"
          links << link
        end
      end
    end

    unselected_links.each do |link| #keeps selected filters at top of list
      links << link
    end
    links
  end
end
