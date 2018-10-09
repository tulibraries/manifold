class EmailDispatcherController < ApplicationController
	def missing_book
		FormsMailer.missing_book(@form).deliver
		# @info = params
		# mail(to: 'cdoyle@temple.edu', subject: 'Missing Book Search Request') do |format|
  #     format.html { render layout: 'missing_book' }
  #     format.text
  #   end
	end
end
