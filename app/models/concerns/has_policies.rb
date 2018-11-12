require 'active_support/concern'

module HasPolicies
  extend ActiveSupport::Concern
  included do
    scope_by_class_name = name
    has_many :policy_applications, -> { where(policyable_type: scope_by_class_name ) }, foreign_key: :policyable_id
    has_many :policies, through: :policy_applications

  end

end
