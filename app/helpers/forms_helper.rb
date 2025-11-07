# frozen_string_literal: true

module FormsHelper
  def breadcrumb_link(type)
    scrc_types = ["av-requests", "copy-requests"]
    if scrc_types.include?(type)
      link_to "SCRC Homepage", webpages_scrc_path, class: "inline"
    else
      link_to "View all forms", forms_path, class: "inline"
    end
  end
end
