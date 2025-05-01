# frozen_string_literal: true

module CategoriesHelper
  def explore_charles(category)
    category.slug == "explore-charles"
  end

  def img_alts
    t("manifold.categories.charles_slide_alt_texts")
  end
end
