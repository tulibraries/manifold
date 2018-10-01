module BuildingsHelper
	def todays_hours
		@todays_hours.first.hours
	end
	def todays_date
		@today.to_date.strftime("%^A, %^B %d, %Y ")
	end
	def phone_formatted
		number_to_phone(@building.phone_number, area_code: true)
	end
end
