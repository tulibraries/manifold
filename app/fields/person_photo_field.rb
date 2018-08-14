require "administrate/field/base"

class PersonPhotoField < Administrate::Field::Base
  def to_s
	    Person.photo.to_s
  end
end
