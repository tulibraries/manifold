require "administrate/field/base"

class SpacePhotoField < Administrate::Field::Base
  def to_s
	    Space.photo.to_s
  end
end
