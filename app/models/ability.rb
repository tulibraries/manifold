# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(account)
    if account.present?
      # Check if this is a FormSubmission-only user (student workers)
      is_form_submission_only = account.admin_group&.managed_entities == ["FormSubmission"]

      if is_form_submission_only
        # FormSubmission-only users are completely locked down to only FormSubmissions
        can :manage, FormSubmission
      else
        # All other authenticated users can read everything
        can :read, :all
      end

      if account.admin?
        # Admins can manage everything
        can :manage, :all
      else
        # Check if this is a FormSubmission-only user (student workers)
        is_form_submission_only = account.admin_group&.managed_entities == ["FormSubmission"]

        unless is_form_submission_only
          # FormSubmission-only users already handled above
          # All other authenticated users get base permissions
          # These entities are openly manageable by any authenticated user
          can :manage, [Building, Space, Person, Group, Service, Collection, Policy, Category]

          # AdminGroup users get ADDITIONAL permissions for their managed entities
          # This is ADDITIVE - they keep base permissions AND get extra ones
          if account.admin_group&.managed_entities&.any?
            account.admin_group.managed_entities.each do |entity_type|
              entity_class = entity_type.constantize rescue nil
              can :manage, entity_class if entity_class
            end
          end

          # Special case: Special Collections users can also manage FormSubmissions
          if account.admin_group&.name == "Special Collections"
            can :manage, FormSubmission
          end
        end

        # Additional permissions for alertors
        if account.alertability?
          can :update, Alert
        end
      end

      # Security restriction: Only admins can manage AdminGroups and Accounts
      # This prevents privilege escalation
      if account.admin?
        can :manage, AdminGroup
        can :manage, Account
      else
        cannot :manage, AdminGroup
        cannot :manage, Account
      end
    end
  end
end
