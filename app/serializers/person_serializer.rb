class PersonSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :first_name, :last_name, :job_title, :email_address, :phone_number, :specialties
  has_many :groups
  has_many :spaces
  has_one :photo, if: Proc.new {|person| person.photo.attached?} do |person|
    person.photo.variant(resize: "100x100").processed.service_url(only_path: true)
  end
end
