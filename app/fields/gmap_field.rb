require "administrate/field/base"

class GmapField < Administrate::Field::Base
  def to_s
    data
  end
end
