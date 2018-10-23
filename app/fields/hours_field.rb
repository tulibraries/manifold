# frozen_string_literal: true

require "administrate/field/base"

class HoursField < Administrate::Field::Base
  def to_s
    data
  end
end
