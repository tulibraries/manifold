class FormsMailer < ApplicationMailer
	default from: 'templelibraries@gmail.com'

	def missing_book(info)
		
		@info = info
		mail(to: 'cdoyle@temple.edu', subject: 'Missing Book Search Request') do |format|
      format.html { render layout: 'missing_book' }
      format.text
    end
	end
end
