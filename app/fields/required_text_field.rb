require "administrate/field/base"

class RequiredTextField < Administrate::Field::Base
  def to_s
    data
  end
end
