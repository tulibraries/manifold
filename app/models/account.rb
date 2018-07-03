class Account < ApplicationRecord
  include Validators

  has_and_belongs_to_many :oauth_credentials

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # [TODO] Replace line below with this: devise :trackable, :timeoutable, :omniauthable, :database_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, email: true

  def self.from_omniauth(access_token)
    data = access_token.info
    account = Account.where(email: data['email']).first
  end
end
