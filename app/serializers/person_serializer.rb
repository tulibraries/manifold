class PersonSerializer
  include FastJsonapi::ObjectSerializer
  
  link :self, Proc.new {|object| Rails.application.routes.url_helpers.person_url(object.id) }
  
  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties
  attribute :photo, if: Proc.new {|person| person.photo.attached?} do |person|
    Rails.application.routes.url_helpers.rails_blob_url(person.photo)
  end
  attribute :thumbnail_photo, if: Proc.new {|person| person.photo.attached?} do |person|
    Rails.application.routes.url_helpers.rails_representation_url(person.photo.variant(resize: "100x100").processed)
  end 
  has_many :groups
  has_many :spaces

end
