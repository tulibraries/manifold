class Account < ApplicationRecord
  include Validators

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :timeoutable, :omniauthable,  
         :database_authenticatable, :registerable,   # TODO: Remove after OAuth implemented
         :recoverable, :rememberable, :validatable   # TODO: Remove after OAuth implemented
 	validates :email, tu_access_email: true
end
