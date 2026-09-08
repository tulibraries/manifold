# frozen_string_literal: true

module ImageHelper
  def render_image(resource, variant: :show)
    index = variant == :index
    source = resource.rendered_image { index ? resource.index_image : resource.fit_image(600, 600) }

    image = if source
      alt_text = resource.alt_text.presence || "#{resource.model_name.human} image for #{resource.title}"
      image_tag(source, class: ("img-fluid event-show-image" unless index), alt: alt_text)
    else
      image_tag("T.png", alt: "Temple T Logo")
    end

    index ? link_to(image, polymorphic_path(resource), target: "_top") : image
  end
end
