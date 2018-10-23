# frozen_string_literal: true

require "administrate/field/base"

class PhoneField < Administrate::Field::String
  def to_s
    data
  end
end
