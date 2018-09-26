class Ability
  include CanCan::Ability

  def initialize(account)
		can :read, [Building, Space, Group, Person, Alert, Service] # permissions for every account, even if not logged in
    if account.present?  # additional permissions for logged in accounts (they can manage their posts)
		  can :read, :all # permissions for every account, even if not logged in
      can :manage, [Building, Space, Person, Group, Alert, Service], account_id: account.id
      if account.admin?  # additional permissions for administrators
        can :manage, :all
      end
    end
  end
end
