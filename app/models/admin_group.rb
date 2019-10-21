# frozen_string_literal: true

class AdminGroup < ApplicationRecord
  has_many :members, class_name: "Account"
end
