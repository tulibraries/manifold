class LibraryHours < ApplicationRecord
	belongs_to :building, optional: true
	belongs_to :space, optional: true
	#belongs_to :service, optional: true
end
