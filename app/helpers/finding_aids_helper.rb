# frozen_string_literal: true

module FindingAidsHelper
  def get_collection_name(id)
    the_name = ""
    @collections.each do |col|
      if col.id == id.to_i
        the_name = col.name
      end
    end
    the_name
  end

  def filter_tags_aids
    tags = []
    unless params[:collection].nil?
      tags << "#{get_collection_name(params[:collection])}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except(:collection).merge(page: 1))}\">X</a>"
    end
    unless params[:subject].nil?
      subjects = params[:subject].split(",")
      subjects.each do |subject|
        tags << "#{subject}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except("," + subject).merge(page: 1))}\">X</a>"
      end
    end
    tags
  end


  def subject_links
    links = []
    unselected_links = []
    unless @subjects.nil?
      unless params[:subject].nil?

        @subjects.each do |subject|
          subjects = params[:subject].split(",")
          if params[:subject].include?(subject)
            subject_removed = subjects.reject { |sub| sub == subject }.uniq.join(",")
            link = '<li class="active"> ' + subject + '
                      <span class="clear-filter">
                        <a href="' + finding_aids_path(request.query_parameters.merge(subject: subject_removed, page: 1)) + '">X</a>
                      </span>
                    </li>'
            links << link
          else
            subjects = subjects.split(",").push(subject).uniq.join(",")
            link = '<li><a href="' + finding_aids_path(request.query_parameters.merge(subject: subjects, page: 1)) + '"> ' + subject + "</a></li>"
            unselected_links << link
          end
        end

      else
        @subjects.each do |subject|
          link = '<li><a href="' + finding_aids_path(request.query_parameters.merge(subject: subject, page: 1)) + '"> ' + subject + "</a></li>"
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
