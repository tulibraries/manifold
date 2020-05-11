# frozen_string_literal: true

require "administrate/field/base"

class DescriptionField < Administrate::Field::Text
  def to_s
    data.html_safe unless data.nil?
  end
end
