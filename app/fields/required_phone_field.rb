require "administrate/field/base"

class RequiredPhoneField < Administrate::Field::String
  def to_s
    data
  end
end
