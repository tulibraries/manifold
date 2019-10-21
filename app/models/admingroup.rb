# frozen_string_literal: true

class Admingroup < ApplicationRecord
  has_many :members, class_name: "Account"
end
