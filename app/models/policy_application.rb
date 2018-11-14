# frozen_string_literal: true

class PolicyApplication < ApplicationRecord
  belongs_to :policyable, polymorphic: true
  belongs_to :policy
end
