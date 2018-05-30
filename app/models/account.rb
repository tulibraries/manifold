class Account < ApplicationRecord
  include Validators

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, 
         :timeoutable, :omniauthable

 	validates :email, tu_access_email: true
end
