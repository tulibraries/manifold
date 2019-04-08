# frozen_string_literal: true

class Category < ApplicationRecord
  include Rails.application.routes.url_helpers
  #TODO: should we validate that icon is svg?
  has_many :categorizations
  has_many :categorizables, through: :categorizations
  has_one_attached :icon

  validates :name, presence: true


  def url
    custom_url ? custom_url : category_url(self)
  end
end
