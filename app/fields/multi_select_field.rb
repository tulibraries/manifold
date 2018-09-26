require "administrate/field/base"

class MultiSelectField < Administrate::Field::Select
  def to_s
    data
  end
end
