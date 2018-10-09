# frozen_string_literal: true

class GroupContact < ApplicationRecord
  belongs_to :group
  belongs_to :person
end
