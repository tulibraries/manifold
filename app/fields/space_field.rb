require "administrate/field/base"

class SpaceField < Administrate::Field::Base
  def to_s
    data
  end
end
