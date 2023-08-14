# frozen_string_literal: true

class Account < ApplicationRecord
  include Validators

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :timeoutable, :omniauthable, :database_authenticatable

  auto_strip_attributes :email

  validates :email, presence: true, email: true

  validates :name, presence: true

  belongs_to :admin_group, optional: true

  has_many :account_form_infos, dependent: :destroy
  has_many :form_infos, through: :account_form_infos


  def self.from_omniauth(access_token)
    data = access_token.info
    account = Account.find_by(email: data["email"])
  end

  def self.lookup(email)
    Account.find_by(email:)
  end
end
