# frozen_string_literal: true

class Accountability < ApplicationRecord
  belongs_to :accountable, polymorphic: true
  belongs_to :account
end
