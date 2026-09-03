# frozen_string_literal: true

module ImageHelper
  def render_image(resource, variant: :show)
    case variant
    when :index
      html_class = nil
      placeholder_class = nil
      sized_image = -> { resource.index_image }
      link_options = { target: "_top" }
    when :featured
      html_class = nil
      placeholder_class = "events-default"
      sized_image = -> { resource.featured_image }
      link_options = {}
    else
      html_class = "img-fluid event-show-image"
      placeholder_class = nil
      sized_image = -> { resource.fit_image(600, 600) }
      link_options = nil
    end

    source = resource.rendered_image(&sized_image)

    unless source
      return image_tag("T.png", class: placeholder_class, alt: "Temple T Logo")
    end

    alt_text = resource.alt_text.presence || "#{resource.model_name.human} image for #{resource.title}"
    image = image_tag(source, class: html_class, alt: alt_text)
    link_options ? link_to(image, polymorphic_path(resource), **link_options) : image
  end
end
