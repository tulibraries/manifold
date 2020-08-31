# frozen_string_literal: true

require "administrate/field/base"
require "administrate/field/text"

class DescriptionField < Administrate::Field::Text
  def to_s
    data
    # data.html_safe unless data.nil?
  end
end
