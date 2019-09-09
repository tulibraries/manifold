# frozen_string_literal: true

module FindingAidsHelper

	def get_collection_name(id)
  	the_name = ""
  	@collections.each do |col|
  		if col.id == id.to_i
  			the_name = col.name
  		end
  	end
  	the_name
  end

  def filter_tags_aids
  	tags = []
  	unless params[:collection].nil? 
  		tags << "#{get_collection_name(params[:collection])}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except(:collection).merge({page: 1}))}\">X</a>"
  	end 
  	unless params[:subject].nil? 
  		subjects = params[:subject].split(',')
  		subjects.each do |subject|
  			tags << "#{subject}&nbsp;<a href=\"#{finding_aids_path(request.query_parameters.except(","+subject).merge({page: 1}))}\">X</a>"
  		end
  	end
  	tags
  end
end
