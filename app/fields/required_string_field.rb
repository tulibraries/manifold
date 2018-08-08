require "administrate/field/base"

class RequiredStringField < Administrate::Field::Base
  def to_s
    data
  end
end
