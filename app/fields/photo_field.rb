require "administrate/field/base"

class PhotoField < Administrate::Field::Base
  def url
  	if data.attached?
	    data.url
	  end
  end

  def thumbnail
  	if data.attached?
	    data.url
	  end
  end

  def to_s
  	if data.attached?
	    data
	  end
  end
end
