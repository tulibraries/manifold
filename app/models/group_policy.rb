# frozen_string_literal: true

class GroupPolicy < ApplicationRecord
  belongs_to :group
  belongs_to :policy
end
