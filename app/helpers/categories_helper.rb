# frozen_string_literal: true

module CategoriesHelper
  def category_url
    klass = @category.name.classify.constantize
    full_url_for(controller: @category.name.pluralize, action: "show", id: klass.first.to_param)
  end

  def category_path
    klass = @category.name.classify.constantize
    url_for(controller: @category.name.pluralize, action: "show", id: klass.first.to_param)
  end
end
