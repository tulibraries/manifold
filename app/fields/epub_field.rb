# frozen_string_literal: true

require "administrate/field/base"

class EpubField < Administrate::Field::Base
  def to_s
    data
  end
end
