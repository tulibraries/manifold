require "administrate/field/base"

class ContactField < Administrate::Field::Base
  def to_s
    data
  end
end
