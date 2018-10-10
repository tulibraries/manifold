# frozen_string_literal: true

require "administrate/field/base"

class MultiSelectField < Administrate::Field::Select
  def to_s
    data
  end
end
