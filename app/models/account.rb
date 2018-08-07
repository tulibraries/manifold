class Account < ApplicationRecord
  include Validators

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :timeoutable, :omniauthable, :database_authenticatable

  validates :email, presence: true, email: true

  auto_strip_attributes :email

  def self.from_omniauth(access_token)
    data = access_token.info
    account = Account.where(email: data['email']).first
  end
end
